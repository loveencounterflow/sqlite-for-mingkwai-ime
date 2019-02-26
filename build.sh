#!/bin/bash
set -euo pipefail

targetname=sqlite3-27-902
echo "building $targetname"
# thx to https://www.sqlite.org/howtocompile.html
gcc shell.c sqlite3.c -lpthread -ldl -o "$targetname"



