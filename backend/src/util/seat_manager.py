from dataclasses import dataclass
from typing import List

from .json_util import read_json

config = read_json("../config/server.json")


@dataclass
class Group:
    """
    * members: 5자리 정수로 이루어진 학번 리스트
    * id: 그룹의 ID, 자동으로 부여됨
    """
    members: List[int]
    id: int


class SeatManager:
    def __new__(cls, *args, **kwargs):
        if not hasattr(cls, 'instance'):
            cls.instance = super(SeatManager, cls).__new__(cls)
            cls.seat_remain: int = config["seat_max_capacity"]
            cls.group: List[Group] = []
            cls.entered_students: List[int] = []

            print("assign new seat manager")
        print("return instance")
        return cls.instance

    def register_group(self, r_group: list) -> Group:
        """
        신청 목록에 그룹 추가\n
        `r_group`: 신청 그룹, 학번으로 구성된 리스트
        """
        group: Group = Group(r_group, hash(tuple(r_group)))
        self.group.append(group)
        return group

    def enter_next_group(self) -> None:
        """
        다음 그룹 입장, 만약 자리가 충분하지 않다면 충분할때까지 대기\n
        *사용 시 반드시 그룹 인원수 이상의 자리가 남아있는지 확인 후 호출*
        """
        next_group = self.group.pop(0)
        self.entered_students.extend(next_group.members)
        self.seat_remain -= len(next_group.members)

    def enter_prior_group(self, p_group: list) -> None:
        """
        우선 급식 그룹 입장\n
        `p_group`: 우선 급식 그룹, 학번으로 구성된 리스트
        """
        self.seat_remain -= len(p_group)

    def enter_student(self, student_id: int) -> None:
        """급식실 입장 시 이 함수 이용"""
        self.seat_remain -= 1
        self.entered_students.append(student_id)

    def exit(self, student_id: int) -> None:
        """퇴장"""
        try:
            self.entered_students.remove(student_id)
            self.seat_remain += 1
        except ValueError:
            pass
