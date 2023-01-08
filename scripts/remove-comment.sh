#!/bin/bash

# ignore comments.
# Do not remove it if \% (literal %).
# Remove it if \\% (newline + comment).
# Do not remove it if \\\% (newline + literal %).
# Remove it if \\\\% (newline + newline + comment).

#        ___________ beginning of line or non-slash character
sed 's/\(\(^\|[^\]\)\(\\\\\)*\)%.*$/\1/g' $1
#                   ^^^^^^^^^ as many double-slashes \\
