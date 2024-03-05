create or replace table prior_students (
    student_id smallint unsigned primary key,
    validation_key char(16) unique key not null
);