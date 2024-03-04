from dataclasses import dataclass


@dataclass
class DBStudentsTable:
    student_id: int
    group_status: int
    had_lunch: bool


@dataclass
class DBTeachersTable:
    teacher_id: str
    had_lunch: bool
