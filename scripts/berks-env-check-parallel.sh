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

echo "Checking environments..."
# set up function & options for `parallel`
function check_env () {
  local env=$1
  echo " > Checking $env..."
  rm -f Berksfile.lock
#  CHEF_ENVIRONMENT=$env berks install ${BERKS_OPTS}
}
export -f check_env
ls environments | sed -e 's/.json//' | parallel --env BERKS_OPTS -i check_env {}

exit 0

envs=$(ls environments | sed -e 's/.json//')
for env in $envs ; do
  echo "Checking $env environment..."
  rm -f Berksfile.lock
  CHEF_ENVIRONMENT=$env berks install ${BERKS_OPTS}
done
echo "Checking provisioning environment..."
cd provisioning
export BERKSHELF_PATH="vendor/"
rm -f Berksfile.lock
berks install ${BERKS_OPTS}
