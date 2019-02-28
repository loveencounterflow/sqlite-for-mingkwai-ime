






.bail on
-- .echo on
.headers on
.mode column
.nullvalue 'x'
.width 50
-- .timer on
-- .help
-- .tables
-- .schema

drop table if exists texnames;
drop table if exists txftsci;
drop table if exists txftscs;


-- ---------------------------------------------------------------------------------------------------------
.print '--=(1)=--'
.mode csv
.import 'tests/texnames.csv' texnames
.mode column
-- select texname, cid_hex, glyph from texnames limit 10;

-- ---------------------------------------------------------------------------------------------------------
.print '--=(2)=--'
select count(*) from texnames;

-- ---------------------------------------------------------------------------------------------------------
.print '--=(3)=--'
create table probes (
    id        integer primary key,
    probe     text unique not null
  );

-- -- ---------------------------------------------------------------------------------------------------------
-- create table results (
--     pid       integer         not null,
--     rid       integer unique  not null,
--     result    text            not null
--   );

-- ---------------------------------------------------------------------------------------------------------
.print '--=(4)=--'
insert into probes ( probe ) values
  -- ( 'e'   ),
  ( 'a'      ),
  ( 'acute-' ),
  ( 'alpha'   ),
  ( 'beta'   ),
  -- ( 'alpha*'  ),
  ( 'Alpha'   ),
  -- ( 'Alpha*'  ),
  -- ( 'arrow downwards'     ),
  -- -- ( 'arrow%'              ),
  -- ( 'greek letter alpha'  ),
  -- ( 'greek letter Alpha'  ),
  -- ( 'greek letter'       ),
  -- ( 'down*'               ),
  ( '日'      ),
  ( 'で'      ),
  ( 'こ' ),
  ( 'これ' ),
  ( 'は' ),
  ( '書' ),
  ( '書かれて' ),
  ( 'これは日本語で書か' ),
  ( 'これは日本語で書かれ' ),
  ( 'これは日本語で書かれて' ),
  ( 'これは日本語で書かれてい' ),
  ( 'これは日本語で書かれていま' ),
  ( 'これは日本語で書かれています' ),
  ( '本'      ),
  ( '日本'      ),
  ( '日本*'     );


.print '--=(5)=--'
.load './extensions/nextchar'

.print '--=(6)=--'
.print 'next characters'
select
    p.probe                                       as probe,
    next_char( probe, 'texnames', 'texname' )     as nextchrs,
    p.id                                          as pid
  from
    probes as p
  order by
    pid;

-- select * from texnames where texname like 'a%';
-- select next_char( 'a', 'texnames', 'texname' );
-- select next_char( 'acute-', 'texnames', 'texname' );
-- select next_char( '日', 'texnames', 'texname' );
-- select next_char( 'で', 'texnames', 'texname' );

-- .load './extensions/regexp'
-- select 'another day at the races' regexp 'da';

-- .load './extensions/series'
-- select * from generate_series( 1, 10, 3 ) as n;

.exit

