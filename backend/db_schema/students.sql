create or replace table students (
    student_id smallint unsigned primary key,
    group_status char(40) default null,
    had_lunch bool not null default false
);