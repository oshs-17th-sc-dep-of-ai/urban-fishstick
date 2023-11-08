from collections import deque
import deque
from flask import Flask, Blueprint, request, jsonify
from datetime import datetime, time

app = Flask(__name__)

entered_blueprint = Blueprint("entered", __name__)

REM_TABLE = 200


# 급식 신청 시간 범위(11시 30분 ~ 11시 40분)
lunch_start_time = time(11, 30)  
lunch_end_time = time(11, 40)    

# 급식 신청 시간 함수
def check_lunch_time():
    now = datetime.now()  
    current_time = now.time()
    return lunch_start_time <= current_time <= lunch_end_time

# 남은 좌석 함수 
def remaining_table(REM_TABLE, entered):
    return REM_TABLE - entered

@entered_blueprint.route("/apply", methods=["POST"])
def push_applicant():
    body = request.get_json()

    # 3학년 급식 시간에 3학년이 아닌 학년이 신청했을 경우 신청 거부
    if len(list(filter(lambda e: e/10000 == 3, body))) != len(body): # body -> 학번으로
        return jsonify({'message': '3학년만 신청이 가능합니다.'}), 403
    
    # 그룹 정보 큐에 추가
    deque.apply_meal(body[""]) # 학번

    # 입장 인원 수
    entered = body.get('entered')

    # 남은 좌석 계산
    REM_TABLE -= entered

    # 남은 테이블 수 업데이트?
    updated_rem_table = remaining_table(REM_TABLE, entered)
    
    # 신청 성공!
    return jsonify({'message': f'현재 남은 좌석 수: {updated_rem_table}'})

# 블루프린트 등록
app.register_blueprint(entered_blueprint)

# 실행
if __name__ == "__main__":
    app.run()
