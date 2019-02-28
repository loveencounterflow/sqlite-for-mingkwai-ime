






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

-- .load './extensions/series'
-- select * from generate_series( 1, 10, 3 ) as n;

.exit






