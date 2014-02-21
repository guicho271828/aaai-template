#! /bin/bash

pages=$(pdftk $2.pdf dump_data | grep NumberOfPages | cut -d' ' -f2)

if test $1 -lt $pages
then
    echo Warning: Max pages exceeded. limit: $1 actual: $pages
    exit 1
else
    echo Info: Max pages within range. limit: $1 actual: $pages
    exit 0
fi
