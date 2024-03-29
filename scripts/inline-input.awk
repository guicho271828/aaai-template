
#
# Find \input command and replace the file content in-place,
# then remove the included file.
#

/.*\\input{.*/ {
    filename = gensub(/.*\\input{(.+)}.*/, "\\1", "g", $0)
    print "inline-input.awk: inlining "filename > "/dev/stderr"
    while ((getline line < filename) > 0)
    {
        print line
    }
    close($0)
    print "inline-input.awk: removing "filename > "/dev/stderr"
    system("rm "filename)
    next
}

{
    print $0
}
