#! /bin/bash
for BOOK in `knife cookbook list | cut -d' ' -f1`; do
    echo -n $BOOK:\ 
    knife search node "recipes:$BOOK*" -i | head -n 1 | cut -d' ' -f1
done
