

# SQLite for MingKwai IME

This repository represents an effort to come to grips with the [SQLite3 compilation
process](https://www.sqlite.org/howtocompile.html) so it becomes feasible to produce custom builds of SQLite
with select options, extensions, and added features.

## What do I get?

At present, very little, but hopefully handy stuff.

* There is a bash script to compile the SQLite engine itself; this produces an executable for the SQLite
  command line utility that knows about all the (very little) changes to SQLite that are made here.

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


