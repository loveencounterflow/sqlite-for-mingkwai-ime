#!/bin/bash
set -euo pipefail

targetname=sqlite3-27-902
echo "building $targetname"
# thx to https://www.sqlite.org/howtocompile.html
# gcc shell.c sqlite3.c -lpthread -ldl -o "$targetname"

# thx to https://www.sqlite.org/howtocompile.html
# `-lm` switch thx to https://www.mail-archive.com/sqlite-users@mailinglists.sqlite.org/msg93715.html
gcc \
  -Os                                     \
  -I.                                     \
  -DSQLITE_THREADSAFE=0                   \
  -DSQLITE_ENABLE_FTS4                    \
  -DSQLITE_ENABLE_FTS5                    \
  -DSQLITE_DEFAULT_FOREIGN_KEYS=1         \
  -DSQLITE_ENABLE_JSON1                   \
  -DSQLITE_ENABLE_RTREE                   \
  -DSQLITE_ENABLE_EXPLAIN_COMMENTS        \
  -DHAVE_USLEEP                           \
  -DHAVE_READLINE                         \
  shell.c sqlite3.c -ldl -lm -lreadline -lncurses -o "$targetname"


# `-lm` switch thx to https://www.mail-archive.com/sqlite-users@mailinglists.sqlite.org/msg93715.html
# gcc -Os shell.c sqlite3.c -DSQLITE_ENABLE_FTS5 -lpthread -lm -ldl -o "$targetname"

# from https://github.com/JoshuaWise/better-sqlite3/blob/master/docs/compilation.md:

#   Any desired compile time options must be defined directly within sqlite3.c.
#
#   By default, this distribution currently uses SQLite3 version 3.26.0 with the following compilation options:
#
#   SQLITE_THREADSAFE=0
#   SQLITE_DEFAULT_MEMSTATUS=0
#   SQLITE_OMIT_DEPRECATED
#   SQLITE_OMIT_GET_TABLE
#   SQLITE_OMIT_TCL_VARIABLE
#   SQLITE_OMIT_PROGRESS_CALLBACK
#   SQLITE_TRACE_SIZE_LIMIT=32
#   SQLITE_DEFAULT_CACHE_SIZE=-16000
#   SQLITE_DEFAULT_FOREIGN_KEYS=1
#   SQLITE_DEFAULT_WAL_SYNCHRONOUS=1
#   SQLITE_USE_URI=1
#   SQLITE_ENABLE_COLUMN_METADATA
#   SQLITE_ENABLE_UPDATE_DELETE_LIMIT
#   SQLITE_ENABLE_STAT4
#   SQLITE_ENABLE_FTS3_PARENTHESIS
#   SQLITE_ENABLE_FTS3
#   SQLITE_ENABLE_FTS4
#   SQLITE_ENABLE_FTS5
#   SQLITE_ENABLE_JSON1
#   SQLITE_ENABLE_RTREE
#   SQLITE_INTROSPECTION_PRAGMAS
#   SQLITE_SOUNDEX
#
