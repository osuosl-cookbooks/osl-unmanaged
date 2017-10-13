#!/bin/bash
set -e

BERKS_OPTS="-q"

while getopts "dr" opt ; do
  case $opt in
    d)
      BERKS_OPTS="-d"
      ;;
    r)
      export DEBUG_RESOLVER=1
      BERKS_OPTS=${BERKS_OPTS/-q/}
      ;;
    *)
      ;;
  esac
done

export BERKSHELF_PATH="vendor/"
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
