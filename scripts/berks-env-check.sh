#!/bin/bash
set -e

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

echo 'Checking environments with parallel script...'

rm -rf testing/

# create specific subdirs to separate the berks runs
function check_env () {
  local env=$1
  mkdir -p testing/$env
  cp Berksfile metadata.rb testing/$env/
  cd testing/$env
  export BERKSHELF_PATH="vendor/"
  rm -f Berksfile.lock
  CHEF_ENVIRONMENT=$env CHEF_ENV_DIR='../../environments' berks install $BERKS_OPTS
}
export BERKS_OPTS
export -f check_env
ls environments | parallel --tagstring {/.}: check_env {/.}
