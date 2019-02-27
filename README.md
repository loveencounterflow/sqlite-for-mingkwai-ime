

# SQLite for MingKwai IME

This repository represents an effort to come to grips with the [SQLite3 compilation
process](https://www.sqlite.org/howtocompile.html) so it becomes feasible to produce custom builds of SQLite
with select options, extensions, and added features.

## What do I get?

At present, very little, but hopefully handy stuff.

* There is a bash script (`./build.sh`) to compile the SQLite engine itself; this produces an executable for
  the SQLite command line utility that knows about all the (very little) changes to SQLite that are made
  here.

* There is another bash script (`./build-extensions.sh`) to build a number of extensions (basically, those
  included in
  [https://www.sqlite.org/cgi/src/.../misc](https://www.sqlite.org/cgi/src/dir?ci=29d02bf2fa9ecacb&name=ext/misc);
  refer to https://www.sqlite.org/cgi/src/doc/trunk/README.md or https://www.sqlite.org/src/zip/sqlite.zip
  to download a current version). This can then be dynamically loaded from a SQL script using the
  `.load 'path/to/extension'` directive. Given a took me some time of wading through a considerable number
  of web pages to pull all of these details together, the current repo may save you some time.

* You may want to take a gander at the compilation incantations in the bash scripts. For the main part,
	that is

	```
	gcc -Os -I. -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_FTS4 \
	   -DSQLITE_ENABLE_FTS5 -DSQLITE_ENABLE_JSON1 \
	   -DSQLITE_ENABLE_RTREE -DSQLITE_ENABLE_EXPLAIN_COMMENTS \
	   -DHAVE_USLEEP -DHAVE_READLINE \
	   shell.c sqlite3.c -ldl -lm -lreadline -lncurses -o "$targetname"
	```

	which is a mouthful. The least part of it, `-lm`, turned out to be essential in conjunction with the
	`-DSQLITE_ENABLE_FTS5` switch that enables Full Test Search v5 functionality; without it, the source
	reference to the `log()` (logarithm) function necessary for FTS5 throws the compiler off (I gather it is
	to mean 'include `-l`ibrary for doing `m`ath' but as far as I'm concerned I'm just throwing magic sticks
	in the hope they will assemble to something useful). This is mentioned in a [mailing list
	thread](https://www.mail-archive.com/sqlite-users@mailinglists.sqlite.org/msg93715.html) but how on Earth
	is one supposed to find this tidbit?

* You can (fork, modify and) use the present repo both for a custom SQLite command line prompt *and* the
  embedded engine that is used by your app (at least that works for NodeJS apps that employ
  `better-sqlite3`); see [below](#using-this-edition-of-sqlite-in-better-sqlite3).

**The great bonus in using your own copy of the SQLite Amalgamation—whether you want a run-of-the-mill
version of SQLite or a heavily modified beast—lies in the opportunity of being able to work with binaries
compiled from the same identical sources**. That is, where before you would use the standard SQLite3
installation of your favorite OS (which for Ubuntu would be SQLite v3.22.0 as of 2019-02-27) for the command
line and the default SQLite3 version as provided by the SQLite engine of your choice (that would be SQLite
v3.26.0 for `better-sqlite3` as of 2019-02-27)—which may differ in quite a few subtle ways—you can now
confidently rely on a set version for both uses.

## Using this edition of SQLite in `better-sqlite3`

To use this version of the SQLite engine with NodeJS and [`better-sqlite3`](https://github.com/JoshuaWise),
just npm-install it with the path to this repo added as value of the `--sqlite3` switch. To quote [the
manual](https://github.com/JoshuaWise/better-sqlite3/blob/master/docs/compilation.md):

> If you want to use a customized version of SQLite3 with `better-sqlite3`, you can do so by specifying the
> directory of your custom amalgamation during installation.
>
> `npm install --sqlite3=/my/path/to/sqlite-amalgamation`
>
> Your amalgamation directory should contain sqlite3.c and sqlite3.h. Any desired compile time options must
> be defined directly within sqlite3.c.


