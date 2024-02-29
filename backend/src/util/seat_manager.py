from dataclasses import dataclass


@dataclass
class Group:
    members: list
    id: int


class SeatManager:
    def __init__(self) -> None:
        self.seat_remain = 10  # 남은 좌석 수
        self.group = []  # 그룹 리스트
        self.entered_students = []  # 입장한 학생

    def enter_next_group(self) -> None:
        """
        다음 그룹 입장, 만약 자리가 충분하지 않다면 충분할때까지 대기
        """
        while self.seat_remain < len(self.group[0].members):  # 테스트 필요
            # 남은 자리보다 그룹 인원이 적다면 자리가 충분할 때 까지 대기
            pass
        self.group.pop(0)

    def register_group(self, r_group: list) -> Group:
        """
        신청 목록에 그룹 추가\n
        `r_group`: 신청 그룹, 학번으로 구성된 리스트
        """
        group = Group(r_group, hash(tuple(r_group)))
        self.group.append(group)
        return group

    def enter_student(self, student_id: int) -> None:
        """
        급식실 입장 시 이 함수 이용
        """
        self.seat_remain -= 1
        self.entered_students.append(student_id)

    def enter_prior_group(self, p_group: list) -> None:
        """
        우선 급식 그룹 입장\n
        `p_group`: 우선 급식 그룹, 학번으로 구성된 리스트
        """
        self.seat_remain -= len(p_group)

    def exit(self, student_id: int) -> None:
        """
        퇴장
        """
        self.seat_remain += 1
        self.entered_students.remove(student_id)
