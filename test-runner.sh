#!/bin/sh

set -e

# this should be defined by the caller (CI runner), but we set a default in
# case we want to run the script by hand.
: ${AWK:="/usr/bin/env awk"}
echo "Testing using $AWK"

# run a test for a give day directory.
ci() {
    DAY=$1
    for part in part1 part2; do
        echo -n "===>" $(basename "$DAY") "($part)... "
        dir="${DAY}/${part}"
        solve="${dir}/solve.awk"
        answer="${dir}/answer.md"
        input="${dir}/../part1/input.txt"
        skip="${dir}/.ci.skip"
        # some tests take too long, we put .ci.skip file into them in order to
        # avoid running them.
        if [ -f "$skip" ]; then
            echo -n "skipping: " && cat "$skip"
        elif [ ! -f "$solve" -o ! -f "$answer" -o ! -f "$input" ]; then
            echo incomplete.
            exit 1
        else
            # the answer file is always one line that looks like:
            #   Your puzzle answer was `foo`.
            expected=$($AWK '{gsub(/`|\./, "", $5); print $5}' "$answer")
            if [ -z "$expected" ]; then
                echo can\'t parse $(basename "$answer")
                exit 1
            fi
            before=$(date "+%s")
            actual=$($AWK -f "$solve" "$input")
            after=$(date "+%s")
            if [ $? -ne 0 ]; then
                echo awk failed.
                exit 1
            elif [ "$actual" != "$expected" ]; then
                echo "bad result, expected ${expected} but got ${actual}"
                exit 1
            fi
            msg="ok"
            # -1 because we might have started at the "end of a second"
            sec=$((after - before - 1))
            [ $sec -gt 0 ] && msg="${msg} (${sec}s)"
            echo "$msg"
        fi
    done
}

# if we get some arguments on ARGV, we're asked to run only a subset of the
# days.
if [ $# -ne 0 ]; then
    for path in "$@"; do
        ci "$path"
    done
else
    # test all the days directories.
    DIR=$(dirname "$0")
    DAYS=$(find "$DIR" -maxdepth 1 -type d -name 'Day [0-9]*')
    echo "$DAYS" | sort | while read day; do
        ci "$day"
    done
fi
