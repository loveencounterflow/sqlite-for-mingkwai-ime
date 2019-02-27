






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
select count(*) from texnames;

-- ---------------------------------------------------------------------------------------------------------
.print '--=(2)=--'
create virtual table txftsci using fts5(
  input,
  output,
  cid_hex,
  tokenize = "ascii"
  );

-- ---------------------------------------------------------------------------------------------------------
.print '--=(3)=--'
create virtual table txftscs using fts5(
  input,
  output,
  cid_hex,
  tokenize = "asciics"
  );

-- ---------------------------------------------------------------------------------------------------------
.print '--=(4)=--'
insert into txftsci ( input, output, cid_hex ) select
    texname,
    glyph,
    cid_hex
  from texnames;

-- ---------------------------------------------------------------------------------------------------------
.print '--=(5)=--'
insert into txftscs ( input, output, cid_hex ) select
    texname,
    glyph,
    cid_hex
  from texnames;

-- ---------------------------------------------------------------------------------------------------------
-- optimize index:
.print '--=(6)=--'
-- insert into txftsci ( txftsci ) values ( 'optimize' );
insert into txftsci ( txftsci ) values ( 'rebuild' );

select count(*) from txftsci;

-- ---------------------------------------------------------------------------------------------------------
create table probes (
    id        integer primary key,
    probe     text unique not null
  );

-- ---------------------------------------------------------------------------------------------------------
create table results (
    pid       integer         not null,
    rid       integer unique  not null,
    result    text            not null
  );

-- ---------------------------------------------------------------------------------------------------------
insert into probes ( probe ) values
  -- ( 'a'   ),
  -- ( 'e'   ),
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
  ( '日本'      ),
  ( '日本*'     );

select * from probes;
-- .exit

.print '--=(7)=--'
.print 'matching against txftsci'
select
    p.id                                        as pid,
    row_number() over ( partition by p.id )     as rid,
    p.probe                                     as probe,
    t.input                                     as input,
    t.output                                    as output,
    t.rank                                      as rank
  from
    probes as p
    join ( select
        bm25( txftsci )     as rank,
        output              as output,
        input               as input,
        cid_hex             as cid_hex
      from txftsci ) as t
    where t.input match p.probe
    order by
      pid,
      rid,
      t.rank;

.print '--=(8)=--'
.print 'matching against txftscs'
select
    p.id                                        as pid,
    row_number() over ( partition by p.id )     as rid,
    p.probe                                     as probe,
    t.input                                     as input,
    t.output                                    as output,
    t.rank                                      as rank
  from
    probes as p
    join ( select
        bm25( txftscs )     as rank,
        output              as output,
        input               as input,
        cid_hex             as cid_hex
      from txftscs ) as t
    where t.input match p.probe
    order by
      pid,
      rid,
      t.rank;

.load './extensions/nextchar'
-- select * from texnames where texname like 'a%';
select next_char( 'a', 'texnames', 'texname' );
select next_char( 'acute-', 'texnames', 'texname' );
select next_char( '日', 'texnames', 'texname' );
select next_char( 'で', 'texnames', 'texname' );

.load './extensions/regexp'
select 'another day at the races' regexp 'da';

-- .load './extensions/series'
-- select * from generate_series( 1, 10, 3 ) as n;

.exit

-- .print '============================================================================================================'
-- select snippet( txftsci, -1, '[', ']', '*', 20 ), * from txftsci where input match '日本' order by bm25( txftsci );



-- -- drop view if exists unicode_entities_01;
-- -- create view unicode_entities_01 as select
-- --     ID                      as ID,
-- --     "UNICODE DESCRIPTION"   as uname,
-- --     Entity                  as entity,
-- --     -- mode                    as mode,
-- --     -- type                    as type,
-- --     -- replace( latex, char( 92 ), '' )                   as latex
-- --     replace( latex, char( 0x5c ), '' )                   as latex
-- --     -- category                as category,
-- --     -- "op dict"               as "op dict",
-- --   from unicode_entities
-- --   -- order by "UNICODE DESCRIPTION"
-- --   order by latex desc
-- --   ;

-- -- select * from unicode_entities_01  limit 100; select count(*) from unicode_entities_01;







