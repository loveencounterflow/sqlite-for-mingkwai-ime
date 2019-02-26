#!/bin/bash
set -euo pipefail

targetname=sqlite3-27-2a
echo "building $targetname"
gcc shell.c sqlite3.c -lpthread -ldl -o "$targetname"



