from collections import deque
from flask import Blueprint, request, jsonify

blueprint = Blueprint(__name__)

q = deque()

rem_table = 200

# 남은 테이블 수 확인
def remaining_tables():
    global rem_table
    return rem_table

# 다음 그룹 입장
def next_group(rem_table, next_group):
    if rem_table >= len(next_group):
        return True
    else:
        return False
    
@blueprint.route("/exit", methods=["POST"])
def exit_group():  # 퇴장 시

    # 그룹의 대표 학번을 전송받음
    student_id = request.get_json().get('representative_student_id')

    # 큐에서 어떤 그룹인지 찾아서 없애기
    for group in q:
        if student_id in [entry.get('student_id') for entry in group]:
            q.remove(group)
            break  
    
    # 좌석 확인
        updated_rem_table = remaining_tables()

    if next_group(updated_rem_table, next_group):
        # 다음 그룹을 입장 허용
        return jsonify({'message': '그룹이 퇴장함. 현재 남은 좌석 수: {}. 다음 그룹 입장'.format(updated_rem_table)})
    else:
        # 다음 그룹을 입장 거부
        return jsonify({'message': '그룹이 퇴장함. 현재 남은 좌석 수: {}. 다음 그룹 입장 불가'.format(updated_rem_table)})
