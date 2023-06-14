
#
# Replace \bibliography command with the content of .bbl files in place,
# then remove the included .bbl file.
#

/.*\\bibliography{.*/ {
    # filename is given by the script that calls this script
    print "inlining "filename > "/dev/stderr"
    while ((getline line < filename) > 0)
    {
        print line
    }
    close($0)
    print "removing "filename > "/dev/stderr"
    system("rm "filename)
    next
}

{
    print $0
}

