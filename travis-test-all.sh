#!/bin/sh

set -e

# this should be injected by TravisCI's env.matrix, but we set a default in
# case we want to run the script by hand.
: ${AWKCMD:="/usr/bin/env awk"}
echo "Testing using $AWKCMD"

# run a test for a give day directory.
travis() {
    DAY=$1
    for part in part1 part2; do
        echo -n "===>" $(basename "$DAY") "($part)... "
        dir="${DAY}/${part}"
        solve="${dir}/solve.awk"
        answer="${dir}/answer.md"
        input="${dir}/../part1/input.txt"
        # some tests take too long, we put .travis.skip file into them in order
        # to avoid running them.
        if [ -f "${dir}/.travis.skip" ]; then
            echo skipping.
        elif [ ! -f "$solve" -o ! -f "$answer" -o ! -f "$input" ]; then
            echo incomplete.
            exit 1
        else
            # the answer file is always one line that looks like:
            #   Your puzzle answer was `foo`.
            expected=$($AWKCMD '{gsub(/`|\./, "", $5); print $5}' "$answer")
            if [ -z "$expected" ]; then
                echo can\'t parse $(basename "$answer")
                exit 1
            fi
            actual=$($AWKCMD -f "$solve" "$input")
            if [ $? -ne 0 ]; then
                echo awk failed.
                exit 1
            elif [ "$actual" != "$expected" ]; then
                echo "bad result, expected ${expected} but got ${actual}"
                exit 1
            fi
            echo ok.
        fi
    done
}

# if we get some arguments on ARGV, we're asked to run only a subset of the
# days.
if [ $# -ne 0 ]; then
    for path in "$@"; do
        travis "$path"
    done
else
    # test all the days directories.
    DIR=$(dirname "$0")
    DAYS=$(find "$DIR" -maxdepth 1 -type d -name 'Day [0-9]*')
    echo "$DAYS" | sort | while read day; do
        travis "$day"
    done
fi
