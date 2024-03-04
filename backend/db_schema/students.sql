create or replace table students (
    student_id smallint unsigned primary key,
    group_status smallint unsigned default null,
    had_lunch bool default null
);