#!/usr/bin/awk -f

BEGIN {
    FS = "" # split the input into one field per character.
}

{
    for (i = 1; i <= NF; i++) {
        if ($i == "(")
            floor++
        else if ($i == ")")
            floor--
    }
}

END {
    print floor
}
