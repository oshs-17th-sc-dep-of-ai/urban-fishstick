class SeatManager:
    def __init__(self) -> None:
        self.registered_group = 0  # 신청한 그룹 수
        self.next_enter  = 0       # 다음 입장 그룹
        self.seat_remain = 10      # 남은 좌석 수
        self.group = []            # 그룹 리스트 (인원 저장됨)
        self.group_ids = []        # 각 그룹의 고유 ID
        self.entered_people = []   # 입장한 인원

    def enter_next_group(self, group_members: list) -> None:
        """
        다음 그룹 입장
        """
        self.entered_people.extend(group_members)
        self.next_enter  += 1
        self.seat_remain -= self.group.pop(0)

    def register_group(self, r_group: list) -> None:
        """
        신청 목록에 그룹 추가\n
        `r_group`: 신청 그룹, 학번으로 구성된 리스트
        """
        self.group.append(len(r_group))
        self.registered_group += 1

    def id(self, group_id: int) -> None:
        """
        그룹 고유 ID 추가\n
        `group_id`: 그룹의 고유 ID
        """
        self.group_ids.append(group_id)

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
        self.entered_people.remove(student_id)
