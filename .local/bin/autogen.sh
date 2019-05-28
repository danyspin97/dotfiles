#!/bin/sh

aclocal -I tools/m4
libtoolize --force --copy
autoheader
autoconf
automake --add-missing --copy
