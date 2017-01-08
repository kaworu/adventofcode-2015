#!/usr/bin/awk -f

BEGIN {
    # split the input into one field per character.
    FS = "";
    # Santa and Robo-Santa start at the same location ...
    pos["Santa", "x"]      = 0; pos["Santa", "y"]      = 0;
    pos["Robo-Santa", "x"] = 0; pos["Robo-Santa", "y"] = 0;
    # ...delivering two presents to the same starting house
    deliver_at(0, 0);
    deliver_at(0, 0);
}

{
    for (i = 1; i <= NF; i++) {
        distributor = (i % 2 ? "Santa" : "Robo-Santa");
        if ($i == "^")
            pos[distributor, "y"]++;
        if ($i == "v")
            pos[distributor, "y"]--;
        if ($i == ">")
            pos[distributor, "x"]++;
        if ($i == "<")
            pos[distributor, "x"]--;
        deliver_at(pos[distributor, "x"], pos[distributor, "y"]);
    }
}

END {
    print houses_delivered;
}

function deliver_at(x, y) {
    if (presents_at[x, y] == 0)
        houses_delivered += 1;
    presents_at[x, y] += 1;
}
