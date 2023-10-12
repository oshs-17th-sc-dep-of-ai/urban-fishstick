from collections import deque

q = deque()

# 급식 신청
def apply_meal(student):
    q.append(student)
    return student

# 입장
def enter(group_leader): 
  if group_leader in q[0]:
    return q.pop()

# 인덱스 함수
def index(student_find):
    """
    큐에서 찾지 못할 경우 -1 반환
    """
    return q.index(student_find) if student_find in q else -1 
