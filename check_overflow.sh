#! /bin/bash

if (cat $1 | grep -E "(Over|Under)full" )
then
    exit 1
fi
