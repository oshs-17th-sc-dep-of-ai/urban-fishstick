from collections import deque
from flask import Blueprint, Flask, request, jsonify

app = Flask(__name__)

q = deque()

REM_TABLE = 200

exit_blueprint = Blueprint("exit", __name__)


# 남은 테이블 수 확인
def remaining_tables():
    return REM_TABLE

# 다음 그룹 입장
def next_group(REM_TABLE, next_group):
    return REM_TABLE >= next_group

@exit_blueprint.route("/exit", methods=["POST"])
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
        return jsonify({'message': f'현재 남은 좌석 수: {updated_rem_table}. 다음 그룹 입장'})
    else:
        # 다음 그룹을 입장 거부
        return jsonify({'message': f'현재 남은 좌석 수: {updated_rem_table}. 다음 그룹 입장 불가'})


# blueprint를 flaks에 등록하는??
app.register_blueprint(exit_blueprint)
    

# 실행
if __name__ == "__main__":
    app.run()
