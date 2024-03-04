create or replace table prior_students (
    student_id smallint unsigned primary key,
    authentication_key char(16) unique key not null
);