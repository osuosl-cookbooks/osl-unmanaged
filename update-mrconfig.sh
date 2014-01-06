#! /bin/bash

if [ ! -d .mrconfig.d ] ; then
    mkdir -p .mrconfig.d
fi

for repo in $(curl -s https://api.github.com/orgs/osuosl-cookbooks/repos |\
    grep \"name\": | cut -d'"' -f 4) ; do
    echo "[osuosl-cookbooks/${repo}]"
    echo "checkout = git clone git@github.com:osuosl-cookbooks/${repo}.git"
    echo
done > .mrconfig.d/github-repos
