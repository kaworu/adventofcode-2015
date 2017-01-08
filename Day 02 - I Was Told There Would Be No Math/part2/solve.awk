#!/usr/bin/awk -f

BEGIN {
    # input lines are like "1x2x3"
    FS = "x";
}

{
    l = $1; w = $2; h = $3;
    # wrapping ribbon (smallest perimeter)
    ribbon += 2 * (l + w + h - max3(l, w, h));
    # ribbon for the bow (cubic volume)
    ribbon += l * w * h;
}

END {
    print ribbon;
}

function max3(a, b, c) {
    return (a > b ? (a > c ? a : c) : (b > c ? b : c));
}
