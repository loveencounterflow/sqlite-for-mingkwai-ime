#!/bin/bash
set -euo pipefail

targetname=sqlite3-27-902
echo "building $targetname"
# thx to https://www.sqlite.org/howtocompile.html
# gcc shell.c sqlite3.c -lpthread -ldl -o "$targetname"

# thx to https://www.sqlite.org/howtocompile.html
# `-lm` switch thx to https://www.mail-archive.com/sqlite-users@mailinglists.sqlite.org/msg93715.html
gcc -Os -I. -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_FTS4 \
   -DSQLITE_ENABLE_FTS5 -DSQLITE_ENABLE_JSON1 \
   -DSQLITE_ENABLE_RTREE -DSQLITE_ENABLE_EXPLAIN_COMMENTS \
   -DHAVE_USLEEP -DHAVE_READLINE \
   shell.c sqlite3.c -ldl -lm -lreadline -lncurses -o "$targetname"


# `-lm` switch thx to https://www.mail-archive.com/sqlite-users@mailinglists.sqlite.org/msg93715.html
# gcc -Os shell.c sqlite3.c -DSQLITE_ENABLE_FTS5 -lpthread -lm -ldl -o "$targetname"
