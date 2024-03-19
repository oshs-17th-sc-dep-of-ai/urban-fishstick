create or replace table prior_students (
    student_id smallint unsigned primary key,
    validation_key char(40) unique key not null,
    author varchar(32) not null
);