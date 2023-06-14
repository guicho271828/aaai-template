#!/bin/bash
#
# Checks all \\input / \\bibliography commands are at the beginning/end of line,
# otherwise exits with status 1.
#

script_dir=$(dirname $(readlink -ef $0))

if awk -f $script_dir/remove-comment.awk $1 | grep '^[^[:space:]]\+\\\(input\|bibliography\){'
then
    echo "\\input command not at the beginning of line (except comments) ! : $1"
    exit 1
fi

if awk -f $script_dir/remove-comment.awk $1 | grep '\\\(input\|bibliography\){[^}]*}[^[:space:]]\+$' $1
then
    echo "\\input command not at the end of line (except comments) ! : $1"
    exit 1
fi

echo "ok! : $1"

