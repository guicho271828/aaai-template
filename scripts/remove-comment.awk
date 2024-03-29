
#
# Remove latex comments from the input file.
# It recognizes "comments" environment from comments package
#

BEGIN {
    in_comment=0
    last_line_was_empty=0
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
                last_line_was_empty = 0
                print result
            }
        } else {
            # we need this if-else because otherwise ordinary empty lines are also removed.
            # we only remove empty lines when it was removed due to comments, or it is a consecutive empty lines.
            if ($0 ~ /^ *$/) { # the entire line is empty.
                if (last_line_was_empty){
                    next
                } else {
                    last_line_was_empty = 1
                    print $0
                }
            } else {
                last_line_was_empty = 0
                print $0
            }
        }
    }
}
