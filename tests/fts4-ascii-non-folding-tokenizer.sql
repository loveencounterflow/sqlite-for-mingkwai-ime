






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

-- drop table if exists customers;
-- CREATE VIRTUAL TABLE customers USING fts5(
--     name,
--     addr,
--     uuid UNINDEXED,
--     -- tokenize = 'unicode61 remove_diacritics 2'
--     tokenize = 'unicode61'
--     );

-- drop table if exists customers;
-- CREATE VIRTUAL TABLE customers USING fts5(a, b,
--     tokenize = "unicode61 categories 'L* N* Co Mn'"
-- );
-- xxx;





/*
drop table if exists foo;
create table foo (
  input   text not null,
  output  text not null );

insert into foo values
  ( 1, 2 ),
  ( 3, 4 ),
  ( 5, 6 ),
  ( 7, 8 ),
  ( 9, 10 ),
  ( 11, 12 ),
  ( 13, 14 ),
  -- ( 13, null ),
  ( 15, 16 );

select * from foo;
*/

-- .show
-- .exit
.print '--=(1)=--'
drop table if exists texnames;
.mode csv
.import 'tests/texnames.csv' texnames

.mode column
select texname, cid_hex, glyph from texnames limit 10;
select count(*) from texnames;

.print '--=(2)=--'
drop table if exists txfts;
create virtual table txfts using fts5(
  input,
  output,
  cid_hex,
  -- tokenize = "unicode61"
  tokenize = "ascii"
  -- tokenize=unicode61 "remove_diacritics=2" );
  -- tokenize = 'unicode61'
  );
  -- tokenize = 'porter ascii' );

.print '--=(3)=--'
insert into txfts ( input, output, cid_hex ) select
    texname,
    glyph,
    cid_hex
  from texnames;

.print '--=(4)=--'
insert into txfts ( input, output, cid_hex ) values
  ( '日本',                                           'japanese', 'xxx' ),
  ( '日本語',                                        'japanese', 'xxx' ),
  ( 'これは日本語で書かれています',                   'japanese', 'xxx' ),
  ( ' これは　日本語の文章を 全文検索するテストです',   'japanese', 'xxx' );

-- optimize index:
.print '--=(5)=--'
-- insert into txfts ( txfts ) values ( 'optimize' );
insert into txfts ( txfts ) values ( 'rebuild' );

select count(*) from txfts;

-- ---------------------------------------------------------------------------------------------------------
create table probes (
    id        integer primary key,
    probe     text unique not null
  );

-- ---------------------------------------------------------------------------------------------------------
create table results (
    probe_id  integer         not null,
    result_id integer unique  not null,
    result    text            not null
  );

-- ---------------------------------------------------------------------------------------------------------
insert into probes ( probe ) values
  ( 'alpha'   ),
  ( 'Alpha'   ),
  ( 'alpha*'  ),
  ( 'Alpha*'  ),
  ( '日本'      ),
  ( '日本*'     );

select * from probes;
.load './extensions/series'
select * from generate_series( 1, 10, 3 ) as n;

.exit

.print '============================================================================================================'
select snippet( txfts, -1, '[', ']', '*', 20 ), * from txfts where input match 'alpha' order by bm25( txfts );

.print '============================================================================================================'
select snippet( txfts, -1, '[', ']', '*', 20 ), * from txfts where input match 'Alpha' order by bm25( txfts );

.print '============================================================================================================'
select snippet( txfts, -1, '[', ']', '*', 20 ), * from txfts where input match 'alpha*' order by bm25( txfts );

.print '============================================================================================================'
select snippet( txfts, -1, '[', ']', '*', 20 ), * from txfts where input match 'Alpha*' order by bm25( txfts );

.print '============================================================================================================'
select snippet( txfts, -1, '[', ']', '*', 20 ), * from txfts where input match '日本' order by bm25( txfts );

.print '============================================================================================================'
select snippet( txfts, -1, '[', ']', '*', 20 ), * from txfts where input match '日本*' order by bm25( txfts );



-- -- select distinct output from txfts where input match 'arrow downwards';
-- -- select * from txfts where output match 'a';
-- -- select * from txfts where input match 'arrow%';
-- -- select matchinfo( txfts, 'y' ), * from txfts where input match 'greek letter alpha';
-- -- select snippet( txfts ), * from txfts where input match 'greek letter alpha';
-- -- select snippet( txfts ), * from txfts where input match 'greek -letter';
-- -- select snippet( txfts ), * from txfts where input match 'down*';


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







