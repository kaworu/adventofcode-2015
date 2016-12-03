#!/usr/bin/awk -f

BEGIN {
    FS = "" # split the input into one field per character.
    THE_BASEMENT = -1
}

{
    for (i = 1; i <= NF; i++) {
        if ($i == "(")
            floor++
        else if ($i == ")")
            floor--
        if (floor == THE_BASEMENT)
            break
    }
}

END {
    # i is the position, if santa never entered the basement then we have:
    # i == (NR + 1)
    print i
}
