#!/bin/bash


# this is a script that asks the name of the target file.
# The result is stored in a file "target".

if ! [ -e target ]
then
    (
        echo "We could not find the metadata for the final output filename."
        echo "It seems this is the first time you run this script in this repository."
        echo "Enter the target filename prefix w/o extension, such as PLT-AsaiM.00 ,"
        echo "as described in"
        echo "https://www.aaai.org/Publications/Author/icaps-submit.php#ArchiveNaming ."
        echo "Note that the above URL applies only to ICAPS conference in 2019."
        echo "You should adjust it for your situation."
        
    ) 1>&2
    read -p "Enter the filename prefix (no whitespace) and hit enter" name
    echo $name > target
fi

cat target
