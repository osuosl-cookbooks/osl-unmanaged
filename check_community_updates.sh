#!/bin/bash

# This script compares the cookbook versions for community cookbooks in your
# chef server to the versions in the opscode community cookbook api and
# reports any discrepancies. It assumes that if a cookbook location
# is not specified in the Berksfile, that it uses :site opscode.

# This script assumes that you have the following installed: chef (knife), jq
# It also assumes it is in the same directory as the Berksfile.

DIR=$(dirname $0)
BERKSFILE=$DIR/Berksfile
COOKBOOKS=$(grep cookbook $BERKSFILE | grep -v , | cut -d' ' -f 2 | tr -d \")

for x in $COOKBOOKS
do
    OSL_VER=$(knife cookbook show $x | awk '{ print $2; }')
    CURRENT_VER=$(curl -s http://cookbooks.opscode.com/api/v1/cookbooks/$x | jq .latest_version | rev | cut -d'/' -f1 | rev | tr -d \" | sed 's/_/./g')
    if ! [ $OSL_VER = $CURRENT_VER ]
      then
        echo For cookbook $x the latest version is $CURRENT_VER, and we use $OSL_VER
    fi
done

