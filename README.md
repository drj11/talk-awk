# A brief introduction to awk

AWK is a programmable text processing tool. The `awk` program comes as
standard with Unix, since 1979 ish, and has been in all major Unix
standards. Named after its creators: Aho, Weinberger, Kernighan.
Grows on the `grep` and `sed` tools.

Invoking awk:

    awk prog file1 ...

`awk` processes its input as a series of *records*. Usually, each
record from the input is terminated by a newline.

An AWK program consists of a series of *pattern* *action*
statements:

    /pattern/ { print "matched" }

## The builtin loop

When it runs the program, `awk` steps through its input one record
at a time, and cycles through the pattern/action statements. The
pattern is matched against the current record, and if it
matches, the corresponding action is executed.

The simplest action is `print` which prints the current record,
and in this case the action can be left out. Pattern, no action:

    /pattern/

Prints every record that matches `/pattern/` (so this is a bit like
`grep`).

## Fields

There are a variety of builtin variables and operators.  `awk` splits
each record into a number of *fields*, accessible with `$1`, `$2`,
and so on. `$0` is the entire record. It's quite often useful to
miss the pattern out (in which case it matches on every line):

    { print $2 }

this prints the second field on every line.

## Quote from shell

`awk` programs often contain characters that are special to the
shell, such as space, double quote, and dollar, and they need
protecting from the shell when you put the `awk` program on the
command line. Single quotes come in handy:

    awk '{ print $2 }' infile

You can also put the awk program in a file and use the `-f`
option:

    awk -f progfile infile

## Numbers

`awk` has numbers and numeric expressions. In a pattern a numeric
expression that evaluates to 0 does not match, and any other
value matches. `NR` is a special variable that stores the
number of records processed so far (including the current one);

    awk 'NR > 1' infile

prints all the lines after the first one.

    NR % 3 == 0    # print every 3rd line

    $1 == $5       # print records where 1st and 5th fields match

    rand() < 0.01  # print a random 1% of all lines

Note that the last example uses floating point numbers. In `awk`,
all numbers are floating point, with care taken to print
integers exactly. Just like JavaScript.

There is a bug in the last example (kind of). Can you spot it?
(it's that `rand()` returns the same sequence each time unless
`srand()` is used; even when using `srand` there's probably not enough
entropy. Short version: Do not expect high quality random numbers).

## Variables

Useful for storing and summing and stuff:

    { s += $5 }

If you run this `awk` program, it won't be very useful. You need
to print `s` after the entire input has been read. `awk` has a
special pattern, `END`, that matches only after the last record
has been processed:

    { s += $5 }
    END { print s }

## Splitting

Normally fields are split by whitespace; you can use the `-F`
option to change it.

    awk -F: '{ print $3 }' /etc/passwd

At ScraperWiki we've have good results using Unit Separator (but
it's a bit hard to type):

    awk -F$(printf '\037') '$1 == 85' Scales.txt

## loops

separate file so that it is one word per line:

    awk '{for(i=1; i<=NF; ++i) {
      print $i
    }'

Of note:

3-part loop syntax borrowed from C. From 1979 to
2005-12-13 this will have been familiar to every programmer.
Now it just looks weird.

`NF` is a magic variable that holds the number of fields in
the current record.

`$i` is the i'th field. You can use variables with `$` and in
fact, `$` is just a (high precedence) operator that takes any
expression.



## built in functions

We're already seen `rand()`. These are also fun:

    length($0)

    index(haystack, needle)

    substr($0, 10)

    gsub(/:/, ".")

    split($1, result, "/")


## More fun stuff

    if($1 ~ /drj/) { stuff }

    print $(NF-1)

    $2 = "blank"

    a[$1] += 1

## What is it good for?


## user defined functions

## file and pipe redirection
