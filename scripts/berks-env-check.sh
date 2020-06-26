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

# NOTE: needs `parallel` installed
# run original script if no parallel
if which env_parallel.bash &> /dev/null; then
  echo 'Checking environments with parallel script...'
else
  echo 'Parallel not found, using original script...'
  ./scripts/berks-env-check-original.sh
  exit $?
fi

source $(which env_parallel.bash)
function check_env () {
  local env=$1
  export BERKSHELF_PATH="vendor/$env/"
  # echo "> checking $env..."
  rm -f Berksfile.lock
  CHEF_ENVIRONMENT=$env berks install $BERKS_OPTS
}
ls environments | env_parallel --tagstring {/.} check_env {/.}

echo "Checking provisioning environment..."
cd provisioning
export BERKSHELF_PATH="vendor/"
rm -f Berksfile.lock
berks install ${BERKS_OPTS}
