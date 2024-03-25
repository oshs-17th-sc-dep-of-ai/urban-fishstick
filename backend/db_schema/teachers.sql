create or replace table teachers (
    teacher_id varchar(32) primary key,
    validation_key char(40) unique key,
    had_lunch bool not null default false
);