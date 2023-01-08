#!/bin/bash -x

script_dir=$(dirname $(readlink -ef $0))

# $1 : input file
tex=$(basename $1)
bbl=$(basename $1 .tex).bbl
texdir=$(dirname $(readlink -ef $1))

# $2 all.subm_fromto file
subm_fromto=$(readlink -ef $2)

tmp=$(mktemp)
trap "rm $tmp" EXIT

################################################################

cd $texdir

echo "inline-tex: removing comments"
awk -f $script_dir/remove-comment.awk $tex > $tmp
cp $tmp $tex

echo "inline-tex: Checking all \\input / \\bibliography commands are at the beginning/end of line"
$script_dir/inline-check.sh $tex || exit 1

echo "inline-tex: replacing pathnames:" $(cat $subm_fromto | while read f t ; do echo -n "$f $t " ; done)
replace -s $(cat $subm_fromto | while read f t ; do echo -n "$f $t " ; done) < $tex > $tmp
diff $tex $tmp
cp $tmp $tex

# why replace, not sed? because the pathnames may contain a letter that conflicts with s///g or s@@@g rules


while (echo "inline-tex: searching \\input" ; grep --color -n '\\input{' $tex)
do
    echo "inline-tex: found \\input above"
    gawk -f $script_dir/inline-input.awk $tex > $tmp
    cp $tmp $tex

    echo "inline-tex: removing comments"
    awk -f $script_dir/remove-comment.awk $tex > $tmp
    cp $tmp $tex

    echo "inline-tex: Checking all \\input / \\bibliography commands are at the beginning/end of line"
    $script_dir/inline-check.sh $tex || exit 1

    echo "inline-tex: replacing pathnames:" $(cat $subm_fromto | while read f t ; do echo -n "$f $t " ; done)
    replace -s $(cat $subm_fromto | while read f t ; do echo -n "$f $t " ; done) < $tex > $tmp
    diff $tex $tmp
    cp $tmp $tex
done

echo "inline-tex: inlining bibitems"
gawk -f $script_dir/inline-bbl.awk -v filename=$bbl < $tex > $tmp
cp $tmp $tex

