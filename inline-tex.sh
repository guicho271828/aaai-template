#!/bin/bash

# $1 : input file

tmp=$(mktemp)
trap "rm $tmp" EXIT

echo "inline-tex: inlining all included files"
echo "inline-tex: Be sure each \\input command is in the beginning of line and is not followed by any texts."
echo "inline-tex: Check it below:"
echo "inline-tex: ================================"
grep "\\\\input" *.tex *.sty
echo "inline-tex: ================================"


while ( grep '^ *\\input{[^}]*} *$' $1 ); do
    echo "found an input line"
    gawk -f $(dirname $0)/inline-tex-sub.awk $1 > $tmp
    cp $tmp $1
done


echo "inline-tex: inlining bibitems"
BIBFILE=`echo $1 | sed 's/.tex/.bbl/'`
gawk -v filename=$BIBFILE '{ if ($0 ~ ".bibliography{") { system("cat "filename); } else { print $0; } }' < $1 > $tmp
cp $tmp $1


