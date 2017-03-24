#!/bin/bash
set -e
export BERKSHELF_PATH="vendor/"
envs=$(ls environments | sed -e 's/.json//')
for env in $envs ; do
  echo "Checking $env environment..."
  rm -f Berksfile.lock
  CHEF_ENVIRONMENT=$env berks install -q
done
echo "Checking provisioning environment..."
cd provisioning
export BERKSHELF_PATH="vendor/"
rm -f Berksfile.lock
berks install -q
