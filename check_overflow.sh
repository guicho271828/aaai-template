#! /bin/bash

if (cat $1 | grep -E "Overfull" )
then
    exit 1
fi
