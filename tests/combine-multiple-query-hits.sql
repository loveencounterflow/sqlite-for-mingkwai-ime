






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
-- .print '--=(1)=--'
.mode csv
.import 'tests/texnames.csv' texnames
.mode column

-- ---------------------------------------------------------------------------------------------------------
-- .print '--=(2)=--'
create virtual table txftsci using fts5(
  input,
  output,
  tokenize = "ascii" );
create virtual table txftscs using fts5(
  input,
  output,
  tokenize = "asciics" );

-- ---------------------------------------------------------------------------------------------------------
-- .print '--=(4)=--'
insert into txftsci ( input, output ) select texname, glyph from texnames;
insert into txftscs ( input, output ) select texname, glyph from texnames;
insert into txftsci ( txftsci ) values ( 'rebuild' );
-- insert into txftsci ( txftsci ) values ( 'optimize' );


-- ---------------------------------------------------------------------------------------------------------
create table queries (
    id      integer primary key,
    query   text not null );

create table query_id (
    id        integer,
    query_id  integer );


-- .print '--=(7)=--'
create view matches_ci as select
    t.*,
    'txftsci'           as source,
    bm25( txftsci )     as rank
  from txftsci as t
  where t.input match 'Alpha';

-- .print '--=(8)=--'
create view matches_cs as select
    t.*,
    'txftscs'           as source,
    bm25( txftscs )     as rank
  from txftscs as t
  where t.input match 'Alpha';

-- .print '--=(9)=--'
create view matches_union as
  select * from matches_ci
  union all select * from matches_cs;

-- .print '--=(10)=--'
create view matches_union_counts as with v1 as ( select
    input                                   as input,
    output                                  as output,
    source                                  as source,
    count(*)      over w                    as count,
    rank                                    as rank,
    row_number()  over w                    as rnr
  from matches_union
  window w as ( partition by output order by rank asc
    rows between unbounded preceding and unbounded following ) )
  select
      input,
      output,
      source,
      count,
      rank
    from v1
    where rnr = 1;

.print '============================================================================================================='
insert into queries ( query ) values
  ( 'alpha' ),
  ( 'Alpha' ),
  ( 'beta' ),
  ( 'Beta' );
select * from queries;

.print '============================================================================================================='
select * from matches_union_counts order by count desc, rank asc;







-- .load './extensions/series'
-- select * from generate_series( 1, 10, 3 ) as n;

.exit






