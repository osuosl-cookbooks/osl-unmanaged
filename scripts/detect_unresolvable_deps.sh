#!/bin/bash

echo "WARNING: this script will take approximately forever to run."
for env in $(knife environment list)
  do
    for cb in $(knife cookbook list | awk '{print $1;}')
      do
        OUTPUT=$(knife solve $cb -E $env 2>&1 1>/dev/null)
        if [ $? -gt 0 ]
          then
            echo "$cb failed in $env with the following output: ${OUTPUT}. Run \"knife solve -E $env $cb\" to find out more."
        fi
    done
done
