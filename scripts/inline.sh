#!/bin/bash -x

replace (){
    subm_fromto=$1
    tmp=$2

    while read f t ; do

        sed -i "s@$f@$t@g" $tmp

        # \documentclass/\usepackage/\bibliographystyle uses only the file names without extensions
        f_ext="${f##*.}"
        t_ext="${t##*.}"
        for ext in sty bst cls
        do
            if [ $f_ext == $ext ] && [ $t_ext == $ext ]
            then
                f_base=${f%.$ext}
                t_base=${t%.$ext}
                sed -i "s@$f_base@$t_base@g" $tmp
            fi
        done

    done < $subm_fromto
}

script_dir=$(dirname $(readlink -ef $0))

# $1 : input file
tex=$(basename $1)
bbl=$(basename $1 .tex).bbl
texdir=$(dirname $(readlink -ef $1))

# $2 all.subm_fromto file
subm_fromto=$(readlink -ef $2)

tmp=$(mktemp)
# echo "$(basename $0): temporary file : $tmp"
trap "rm $tmp" EXIT

################################################################

cd $texdir

echo "$(basename $0): removing comments"
awk -f $script_dir/remove-comment.awk $tex > $tmp
cp $tmp $tex

echo "$(basename $0): Checking all \\input / \\bibliography commands are at the beginning/end of line"
$script_dir/inline-check.sh $tex || exit 1

echo "$(basename $0): replacing pathnames:" $(cat $subm_fromto | while read f t ; do echo -n "$f $t " ; done)
replace $subm_fromto $tmp
diff $tex $tmp
cp $tmp $tex

while (echo "$(basename $0): searching \\input" ; grep --color -n '\\input{' $tex)
do
    echo "$(basename $0): found \\input above"
    gawk -f $script_dir/inline-input.awk $tex > $tmp
    cp $tmp $tex

    echo "$(basename $0): removing comments"
    awk -f $script_dir/remove-comment.awk $tex > $tmp
    cp $tmp $tex

    echo "$(basename $0): Checking all \\input / \\bibliography commands are at the beginning/end of line"
    $script_dir/inline-check.sh $tex || exit 1

    echo "$(basename $0): replacing pathnames:" $(cat $subm_fromto | while read f t ; do echo -n "$f $t " ; done)
    replace $subm_fromto $tmp
    diff $tex $tmp
    cp $tmp $tex
done

echo "$(basename $0): inlining bibitems"
gawk -f $script_dir/inline-bbl.awk -v filename=$bbl < $tex > $tmp
cp $tmp $tex

