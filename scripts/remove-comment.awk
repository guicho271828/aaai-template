
BEGIN {
    in_comment=0
}

/.*\\begin{comment}.*/ {
    in_comment+=1               # support nested comments
    sub(/\\begin{comment}.*/,"")
    print
    next
}

/.*\\end{comment}.*/ {
    in_comment-=1               # support nested comments
    sub(/.*\\end{comment}/,"")
    print
    next
}

/.*BEGIN SUBMISSION.*/ {
    in_comment+=1
    next
}

/.*END SUBMISSION.*/ {
    in_comment-=1
    next
}

{
    if (in_comment>0) {
        next
    } else {
        # Ignore comments.
        # Do not remove it if \% (literal %).
        # Remove it if \\% (newline + comment).
        # Do not remove it if \\\% (newline + literal %).
        # Remove it if \\\\% (newline + newline + comment).

        #          _________ beginning of line or non-slash character
        #                   ______ as many double-slashes \\
        if ($0 ~ /((^|[^\\])(\\\\)*)%.*/) {
            result = gensub(/((^|[^\\])(\\\\)*)%.*/,"\\1","g",$0)
            if (result ~ /^ *$/) {
                next                # the entire line is a comment
            } else {
                print result
            }
        } else {
            # we need this if-else because otherwise ordinary empty lines are also removed.
            # we only remove empty lines when it was removed due to comments.
            print $0
        }
    }
}
