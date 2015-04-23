# A brief introduction to awk

AWK is a programmable text processing tool. The awk program comes as
standard with Unix, since 1979 ish, and has been in all major Unix
standards. Named after its creators: Aho, Weinberger, Kernighan.
Grows on the grep and sed tools.

Invoking awk:

    awk prog file1 ...

awk processes its input as a series of *records*. Usually, each
record from the input is terminated by a newline.

An AWK program consists of a series of *pattern* *action*
statements:

    /pattern/ { print "matched" }

## The builtin loop

When it runs the program, awk steps through its input one record
at a time, and cycles through the pattern/action statements. The
pattern is matched against the currect record, and if it
matches, the corresponding action is executed.

The simplest action is `print` which prints the current record,
and in this case the action can be left out. Pattern, no action:

    /pattern/

Prints every record that matches /pattern/ (so this is a bit like grep).

## Fields

There are a variety of builtin variables and operators.  awk splits
each record into a number of *fields*, accessible with `$1`, `$2`,
and so on. `$0` is the entire record. It's quite often useful to
miss the pattern out (in which case it matches on every line):

    { print $2 }

this prints the second field on every line.

## Quote from shell

awk programs often contain characters that are special to the
shell, such as space, double quote, and dollar, and they need
protecting from the shell when you put the awk program on the
command line. Single quotes come in handy:

    awk '{ print $2 }' infile

You can also put the awk program in a file and use the `-f`
option:

    awk -f progfile infile

## Numbers

awk has numbers and numeric expressions. In a pattern a numeric
expression that evaluates to 0 does not match, and any other
value matches. `NR` is a special variable that stores the
number of records processed so far (including the current one);
`NF` stores the number of fields in the current record.

    awk 'NR > 1' infile

prints all the lines after the first one.

    NR % 3 == 0    # print every 3rd line

    $1 == $5       # print records where 1st and 5th fields match

    rand() < 0.01  # print a random 1% of all lines

Note that the last example uses floating point numbers. In awk,
all numbers are floating point, with care taken to print
integers exactly. Just like JavaScript.

## Variables

Useful for storing and summing and stuff:

    { s += $5 }

If you run this awk program, it won't be very useful. You need
to print `s` after the entire input has been read. awk has a
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

You can also split any string you have:

    split($1, result, "/")


## Regular expression as operator

## if, for

## associative arrays

## built in functions

## user defined functions

## file and pipe redirection
