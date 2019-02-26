#!/bin/bash
set -euo pipefail

mkdir -p extensions
echo "building amatch.c      	" ; gcc -g -fPIC -shared -I. extension-sources/misc/amatch.c       -o extensions/amatch.so
echo "building anycollseq.c  	" ; gcc -g -fPIC -shared -I. extension-sources/misc/anycollseq.c   -o extensions/anycollseq.so
echo "building appendvfs.c   	" ; gcc -g -fPIC -shared -I. extension-sources/misc/appendvfs.c    -o extensions/appendvfs.so
echo "building btreeinfo.c   	" ; gcc -g -fPIC -shared -I. extension-sources/misc/btreeinfo.c    -o extensions/btreeinfo.so
echo "building carray.c      	" ; gcc -g -fPIC -shared -I. extension-sources/misc/carray.c       -o extensions/carray.so
echo "building closure.c     	" ; gcc -g -fPIC -shared -I. extension-sources/misc/closure.c      -o extensions/closure.so
echo "building completion.c  	" ; gcc -g -fPIC -shared -I. extension-sources/misc/completion.c   -o extensions/completion.so
echo "building compress.c    	" ; gcc -g -fPIC -shared -I. extension-sources/misc/compress.c     -o extensions/compress.so
echo "building csv.c         	" ; gcc -g -fPIC -shared -I. extension-sources/misc/csv.c          -o extensions/csv.so
echo "building dbdump.c      	" ; gcc -g -fPIC -shared -I. extension-sources/misc/dbdump.c       -o extensions/dbdump.so
echo "building eval.c        	" ; gcc -g -fPIC -shared -I. extension-sources/misc/eval.c         -o extensions/eval.so
echo "building explain.c     	" ; gcc -g -fPIC -shared -I. extension-sources/misc/explain.c      -o extensions/explain.so
echo "building fileio.c      	" ; gcc -g -fPIC -shared -I. extension-sources/misc/fileio.c       -o extensions/fileio.so
echo "building fuzzer.c      	" ; gcc -g -fPIC -shared -I. extension-sources/misc/fuzzer.c       -o extensions/fuzzer.so
echo "building ieee754.c     	" ; gcc -g -fPIC -shared -I. extension-sources/misc/ieee754.c      -o extensions/ieee754.so
# echo "building json1.c       	" ; gcc -g -fPIC -shared -I. extension-sources/misc/json1.c        -o extensions/json1.so
echo "building memstat.c     	" ; gcc -g -fPIC -shared -I. extension-sources/misc/memstat.c      -o extensions/memstat.so
# echo "building memtrace.c    	" ; gcc -g -fPIC -shared -I. extension-sources/misc/memtrace.c     -o extensions/memtrace.so
echo "building memvfs.c      	" ; gcc -g -fPIC -shared -I. extension-sources/misc/memvfs.c       -o extensions/memvfs.so
echo "building mmapwarm.c    	" ; gcc -g -fPIC -shared -I. extension-sources/misc/mmapwarm.c     -o extensions/mmapwarm.so
echo "building nextchar.c    	" ; gcc -g -fPIC -shared -I. extension-sources/misc/nextchar.c     -o extensions/nextchar.so
echo "building normalize.c   	" ; gcc -g -fPIC -shared -I. extension-sources/misc/normalize.c    -o extensions/normalize.so
echo "building percentile.c  	" ; gcc -g -fPIC -shared -I. extension-sources/misc/percentile.c   -o extensions/percentile.so
echo "building prefixes.c    	" ; gcc -g -fPIC -shared -I. extension-sources/misc/prefixes.c     -o extensions/prefixes.so
echo "building regexp.c      	" ; gcc -g -fPIC -shared -I. extension-sources/misc/regexp.c       -o extensions/regexp.so
echo "building remember.c    	" ; gcc -g -fPIC -shared -I. extension-sources/misc/remember.c     -o extensions/remember.so
echo "building rot13.c       	" ; gcc -g -fPIC -shared -I. extension-sources/misc/rot13.c        -o extensions/rot13.so
echo "building scrub.c       	" ; gcc -g -fPIC -shared -I. extension-sources/misc/scrub.c        -o extensions/scrub.so
echo "building series.c      	" ; gcc -g -fPIC -shared -I. extension-sources/misc/series.c       -o extensions/series.so
echo "building sha1.c        	" ; gcc -g -fPIC -shared -I. extension-sources/misc/sha1.c         -o extensions/sha1.so
echo "building shathree.c    	" ; gcc -g -fPIC -shared -I. extension-sources/misc/shathree.c     -o extensions/shathree.so
echo "building showauth.c    	" ; gcc -g -fPIC -shared -I. extension-sources/misc/showauth.c     -o extensions/showauth.so
echo "building spellfix.c    	" ; gcc -g -fPIC -shared -I. extension-sources/misc/spellfix.c     -o extensions/spellfix.so
echo "building sqlar.c       	" ; gcc -g -fPIC -shared -I. extension-sources/misc/sqlar.c        -o extensions/sqlar.so
echo "building stmt.c        	" ; gcc -g -fPIC -shared -I. extension-sources/misc/stmt.c         -o extensions/stmt.so
echo "building templatevtab.c	" ; gcc -g -fPIC -shared -I. extension-sources/misc/templatevtab.c -o extensions/templatevtab.so
echo "building totype.c      	" ; gcc -g -fPIC -shared -I. extension-sources/misc/totype.c       -o extensions/totype.so
echo "building unionvtab.c   	" ; gcc -g -fPIC -shared -I. extension-sources/misc/unionvtab.c    -o extensions/unionvtab.so
echo "building vfslog.c      	" ; gcc -g -fPIC -shared -I. extension-sources/misc/vfslog.c       -o extensions/vfslog.so
echo "building vfsstat.c     	" ; gcc -g -fPIC -shared -I. extension-sources/misc/vfsstat.c      -o extensions/vfsstat.so
echo "building vtablog.c     	" ; gcc -g -fPIC -shared -I. extension-sources/misc/vtablog.c      -o extensions/vtablog.so
echo "building vtshim.c      	" ; gcc -g -fPIC -shared -I. extension-sources/misc/vtshim.c       -o extensions/vtshim.so
echo "building wholenumber.c 	" ; gcc -g -fPIC -shared -I. extension-sources/misc/wholenumber.c  -o extensions/wholenumber.so
echo "building zipfile.c     	" ; gcc -g -fPIC -shared -I. extension-sources/misc/zipfile.c      -o extensions/zipfile.so
echo "building zorder.c      	" ; gcc -g -fPIC -shared -I. extension-sources/misc/zorder.c       -o extensions/zorder.so

