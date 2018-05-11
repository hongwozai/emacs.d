#!/usr/bin/awk -f
# '\' multiline -> oneline
{
    if (match($0,/\\$/)) {
        gsub(/\\$/,"",$0);
        printf("%s", $0);
    } else {
        printf("%s\n", $0);
    }
}