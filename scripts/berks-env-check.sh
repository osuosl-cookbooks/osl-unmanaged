#!/bin/bash
set -e
set -a # autoexport variables for parallel

BERKS_OPTS="-q"
CHEF_ENV=""
while getopts "dre:" opt ; do
  case $opt in
    d)
      BERKS_OPTS="-d"
      ;;
    r)
      export DEBUG_RESOLVER=1
      BERKS_OPTS=${BERKS_OPTS/-q/}
      ;;
    e)
      CHEF_ENV=$OPTARG
      ;;
    *)
      ;;
  esac
done

export BERKSHELF_PATH="vendor/"

if [ -n "${CHEF_ENV}" ] ; then
  echo "Checking $CHEF_ENV environment..."
  rm -f Berksfile.lock
  CHEF_ENVIRONMENT=$CHEF_ENV berks install ${BERKS_OPTS}
  exit 0
fi

# NOTE: needs `parallel` installed, will use old script of not installed
if which parallel &> /dev/null; then
  echo 'Checking environments with parallel script...'
else
  echo 'Parallel not found, using original script...'
  ./scripts/berks-env-check-original.sh
  exit $?
fi

# create specific subdirs to separate the berks runs
function check_env () {
  mkdir -p testing/$1
  cp Berksfile testing/$1/Berksfile
  cp metadata-paralleltesting.rb testing/$1/metadata.rb
  cd testing/$1
  rm -f Berksfile.lock
  CHEF_ENVIRONMENT=$1 berks install $BERKS_OPTS
}
export -f check_env
ls environments | parallel --tagstring {/.}: check_env {/.}

echo "Checking provisioning environment..."
cd provisioning
export BERKSHELF_PATH="vendor/"
rm -f Berksfile.lock
berks install ${BERKS_OPTS}
