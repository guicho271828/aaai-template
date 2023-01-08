#!/bin/bash

script_dir=$(dirname $(readlink -ef $0))

if $script_dir/remove-comment.sh $1 | grep '^[^[:space:]]\+\\\(input\|bibliography\){'
then
    echo "\\input command not at the beginning of line (except comments) ! : $1"
    exit 1
fi

if $script_dir/remove-comment.sh $1 | grep '\\\(input\|bibliography\){[^}]*}[^[:space:]]\+$' $1
then
    echo "\\input command not at the end of line (except comments) ! : $1"
    exit 1
fi

echo "ok! : $1"

