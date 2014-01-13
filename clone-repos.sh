#! /bin/bash

#adding test comment

COOKBOOKS_DIR=osuosl-cookbooks

# Enable explicit output
set -x

# Create the osuosl-cookbooks directory
if [ ! -d $COOKBOOKS_DIR ]; then
    mkdir $COOKBOOKS_DIR
fi

cd $COOKBOOKS_DIR

# Disable explicit output
set +x

# 1) Get a JSON file of repo metadata.
curl -s https://api.github.com/orgs/osuosl-cookbooks/repos |\
# 2) Get the git url for each repo.
grep ssh_url |\
# 3) Remove all extra characters.
cut -d'"' -f 4 |\
# 4) Clone up to 8 repos at a time.
xargs -P8 -n1 git clone
