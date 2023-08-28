from collections import deque

q = deque()

# 급식 신청
def apply_meal(student):
    q.append(student)
    return student

# 입장
def enter(leave_person):
    if leave_person == len(q[0]):
        return q.pop()

# 인덱스 함수
def index(student_find):
    if student_find in q:
        return q.index(student_find)