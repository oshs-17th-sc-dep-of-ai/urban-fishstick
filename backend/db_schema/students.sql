create or replace table students (
    student_id   smallint unsigned primary key  ,
    student_code char(8)  not null unique  key  ,
    group_status char(40)          default null ,
    prior_key    char(40)          default null ,
    had_lunch    bool     not null default false,
    cheat_count  int               default 0
);