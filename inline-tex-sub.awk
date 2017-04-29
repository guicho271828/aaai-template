#!/usr/bin/awk -f

/^ *\\input/ {
    sub(/ *\\input{/,"")
    sub(/}/, "")
    print "inlining "$0 > "/dev/stderr"
    while ((getline line < $0) > 0)
    {
        print line
    }
    close($0)
    print "removing "$0 > "/dev/stderr"
    system("rm "$0)
}

{
    print $0
}
