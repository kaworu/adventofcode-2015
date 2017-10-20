# Advent of Code 2015

https://adventofcode.com puzzles solutions in [AWK][].

> Advent of Code is a series of small programming puzzles for a variety of
> skill levels. They are self-contained and are just as appropriate for an
> expert who wants to stay sharp as they are for a beginner who is just
> learning to code. Each puzzle calls upon different skills and has two parts
> that build on a theme.

## Why AWK?

After solving the firsts two or three puzzle, I thought that AWK would be an
ideal language. The puzzle input is (usually) to be parsed either line-by-line
or sometimes character-by-character; AWK excel at both.

Then [day 4](Day 04 - The Ideal Stocking Stuffer) required to compute *a lot*
of MD5 hashes and it became quite challenging due to AWK's limitations. Using
pipe has serious performance and portability impact, [dynamic extensions][] is
limited to Gawk and greatly limit usability. Implementing MD5 in pure AWK is
tricky because it lacks bitwise operators (Gawk and busybox awk have them
though).

Also puzzles gets harder as days goes by, to the point that finding elegant AWK
solution become really challenging. The most outstanding limitations are:

- Only two scalar types (if we omit regexp): strings and Double-precision
  floating-point numbers.
- The only composite type — associative arrays — is not recursive (values are
  limited to numbers or strings).
- It is not possible to return associative arrays from functions.
- There are very few built-in functions and (almost) all of them are string
  processing functions.

[AWK]: https://en.wikipedia.org/wiki/AWK
[dynamic extensions]: https://www.gnu.org/software/gawk/manual/html_node/Dynamic-Extensions.html
