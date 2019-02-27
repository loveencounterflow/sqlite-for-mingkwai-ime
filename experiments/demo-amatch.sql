


.bail on
-- .echo on
.headers on
.mode column
.nullvalue 'x'
.width 10
-- .timer on
-- .help
-- .tables
-- .schema

-- ---------------------------------------------------------------------------------------------------------
.print '--=(1)=--'
.load './extensions/amatch'


-- ---------------------------------------------------------------------------------------------------------
.print '--=(2)=--'
drop table if exists amatch_vtable;
drop table if exists edit_costs;
drop table if exists vocabulary;
drop index if exists v_index;

-- ---------------------------------------------------------------------------------------------------------
.print '--=(3)=--'
create table vocabulary (
    word        text,
    language_id integer default 0 );
create index v_index on vocabulary( word );

-- ---------------------------------------------------------------------------------------------------------
.print '--=(3)=--'
insert into vocabulary ( word ) values ( 'abc'          );
-- insert into vocabulary ( word ) values ( 'acb'          );
-- insert into vocabulary ( word ) values ( 'bac'          );
-- insert into vocabulary ( word ) values ( 'bca'          );
-- insert into vocabulary ( word ) values ( 'bcd'          );
-- insert into vocabulary ( word ) values ( 'def'          );
insert into vocabulary ( word ) values ( 'dog'          );
insert into vocabulary ( word ) values ( 'abcdef'       );
insert into vocabulary ( word ) values ( 'tree'         );
insert into vocabulary ( word ) values ( 'house'        );
insert into vocabulary ( word ) values ( 'bark'         );
insert into vocabulary ( word ) values ( 'bank'         );
insert into vocabulary ( word ) values ( 'banks'         );
insert into vocabulary ( word ) values ( 'banking'         );
insert into vocabulary ( word ) values ( 'bad'         );
insert into vocabulary ( word ) values ( 'bath'         );
insert into vocabulary ( word ) values ( 'bathe'         );
insert into vocabulary ( word ) values ( 'lathe'         );
insert into vocabulary ( word ) values ( 'lawn'         );
insert into vocabulary ( word ) values ( 'cat'          );
insert into vocabulary ( word ) values ( 'cats'         );
insert into vocabulary ( word ) values ( 'kitten'       );
insert into vocabulary ( word ) values ( 'dogs'         );
insert into vocabulary ( word ) values ( 'learn'         );
insert into vocabulary ( word ) values ( 'stealth'         );
insert into vocabulary ( word ) values ( 'health'         );
insert into vocabulary ( word ) values ( 'wether'         );
insert into vocabulary ( word ) values ( 'whether'         );

-- ---------------------------------------------------------------------------------------------------------
.print '--=(4)=--'
create table edit_costs(
    language_id integer,
    cfrom       text,
    cto         text,
    cost        integer );

-- ---------------------------------------------------------------------------------------------------------
.print '--=(5)=--'
-- insert into edit_costs values(  0, '',    'a',  8 );
-- insert into edit_costs values(  0, 'b',   '',   7 );
-- insert into edit_costs values(  0, 'o',   'oe',  38 );
-- insert into edit_costs values(  0, 'oe',  'o',   40 );
insert into edit_costs values(  0, '',    '?',  10 );
insert into edit_costs values(  0, '?',   '',   20 );
insert into edit_costs values(  0, '?',   '?',  20 );
insert into edit_costs values(  0, 'c',   'k',  5 );
insert into edit_costs values(  0, 'k',   'c',  5 );
insert into edit_costs values(  0, 'ae',   'ea',  5 );
insert into edit_costs values(  0, 'ea',   'ae',  5 );
insert into edit_costs values(  0, 'wh',   'w',  5 );
insert into edit_costs values(  0, 'w',   'wh',  5 );

-- ---------------------------------------------------------------------------------------------------------
.print '--=(6)=--'
create virtual table amatch_vtable using approximate_match(
   vocabulary_table=vocabulary,
   vocabulary_word=word,
   -- vocabulary_language=language_id,
   edit_distances=edit_costs );

-- ---------------------------------------------------------------------------------------------------------
.print '--=(9)=--'
select
    word,
    distance
  from amatch_vtable
  where true
    and ( distance <= 100 )
    -- and ( word match 'abc' )
    -- and ( word match 'xxxx' )
    -- and ( word match 'cat' )
    -- and ( word match 'dog' )
    -- and ( word match 'television' )
    -- and ( word match 'treetop' )
    -- and ( word match 'bath' )
    -- and ( word match 'kat' )
    -- and ( word match 'laern' )
    and ( word match 'wheather' )
    ;





