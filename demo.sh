#!/usr/bin/env bash

# Script to demonstrate features of colorama

# This demo, which can manually be visually verified, exists because we don't
# have an automated system test.

# Implemented as a bash script which invokes python so that we can test the
# behaviour on exit, which resets default colors again.


# example of common usage
python 2>err <<EOF
import sys
from colorama import init, Fore, Back, Style

init()

print Fore.GREEN + 'green' + Fore.RED + 'red' + Fore.RESET + 'normal',
print Back.GREEN + 'green' + Back.RED + 'red' + Back.RESET + 'normal',
print Style.DIM + 'dim' + \
    Style.NORMAL + 'normal' + \
    Style.BRIGHT + 'bright'
print Style.RESET_ALL
EOF


# print grid of all colors and brightnesses
# uses stdout.write to write chars with no newline nor spaces between them
python 2>err <<EOF2
import sys
from colorama import init, Fore, Back, Style

init()

FORES = [
    Fore.BLACK,
    Fore.RED,
    Fore.GREEN,
    Fore.YELLOW,
    Fore.BLUE,
    Fore.MAGENTA,
    Fore.CYAN,
    Fore.WHITE,
]
BACKS = [
    Back.BLACK,
    Back.RED,
    Back.GREEN,
    Back.YELLOW,
    Back.BLUE,
    Back.MAGENTA,
    Back.CYAN,
    Back.WHITE,
]
STYLES = [
    Style.DIM,
    Style.NORMAL,
    Style.BRIGHT,
]

NAMES = {
    Fore.BLACK: 'black',
    Fore.RED: 'red',
    Fore.GREEN: 'green',
    Fore.YELLOW: 'yellow',
    Fore.BLUE: 'blue',
    Fore.MAGENTA: 'magenta',
    Fore.CYAN: 'cyan',
    Fore.WHITE: 'white',
    Fore.RESET: 'reset',
    Back.BLACK: 'black',
    Back.RED: 'red',
    Back.GREEN: 'green',
    Back.YELLOW: 'yellow',
    Back.BLUE: 'blue',
    Back.MAGENTA: 'magenta',
    Back.CYAN: 'cyan',
    Back.WHITE: 'white',
    Back.RESET: 'reset',
}

sys.stdout.write('        ')
for foreground in FORES:
    sys.stdout.write('%s%-7s' % (foreground, NAMES[foreground]))
print

for background in BACKS:
    sys.stdout.write('%s%-7s%s %s' %
       (background, NAMES[background], Back.RESET, background))

    for foreground in FORES:
        sys.stdout.write(foreground)

        for brightness in STYLES:
            sys.stdout.write(brightness)

            sys.stdout.write('X ')

        sys.stdout.write(Style.RESET_ALL + ' ' + background)

    print Style.RESET_ALL
print
EOF2


# check autoreset works
# check reset_all is called at exit
python <<EOF3
import sys
from colorama import init, Fore, Back, Style

init(autoreset=True)
print
print Fore.CYAN + Back.MAGENTA + Style.BRIGHT + 'colored', 'autoreset'

init(autoreset=False)
print Fore.YELLOW + Back.BLUE + Style.BRIGHT + 'colored',
EOF3
echo 'reset at exit'


# check ANSI is stripped from redirected stdout
python >out <<EOF4
import sys
from colorama import init, Fore
init()

print Fore.RED + 'redirected stdout should contain no ansi'
EOF4
cat out


# check that ANSI is stripped from redirected stderr, and that stripped ANSI in
# redirected stderr does not affect stdout
python 2>err <<EOF2
import sys
from colorama import init, Fore

init()

print Fore.RED + 'Red stdout.',
print >>sys.stderr, Fore.BLUE + 'redirected stderr should contain no ansi'

print 'Further stdout should also be red'
EOF2
cat err


# clean up
rm -rf err out

