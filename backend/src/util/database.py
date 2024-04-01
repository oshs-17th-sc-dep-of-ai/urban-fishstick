from dataclasses import dataclass
from typing import Any, List

import pymysql


@dataclass
class DBStudentsTable:
    student_id: int
    group_status: int
    had_lunch: bool


@dataclass
class DBTeachersTable:
    teacher_id: str
    had_lunch: bool


@dataclass
class QueryResult:
    affected_rows: int
    result: Any


class DatabaseUtil:
    def __init__(self, host: str, password: str) -> None:
        self.db_conn = pymysql.connect(
            host=host,
            user="ohsung_lunch",
            passwd=password,
            db="ohsung_lunch"
        )
        self.cursor = self.db_conn.cursor()

    def query(self, sql: str, **kwargs) -> QueryResult:
        affected = self.cursor.execute(sql, kwargs)
        result = self.cursor.fetchall()
        return QueryResult(affected, result)

    def query_many(self, sql: str, args: List[Any]) -> QueryResult:
        affected = self.cursor.executemany(sql, args)
        result = self.cursor.fetchall()
        return QueryResult(affected, result)

    def commit(self) -> None:
        self.db_conn.commit()

    def close(self) -> None:
        self.db_conn.close()
