from collections import deque
from flask import Flask, request, jsonify
from datetime import datetime, time

app = Flask(__name__)

q = deque()

@app.route("/apply", methods=["POST"])
def push_applicant():
    body = request.get_json()

    # 3학년 급식 시간에 신청했을 경우 신청 거부
    if body.get('grade') == 3 and check_lunch_time():
        # 요청이 서버에 의해 거부 403코드!! 기억해ㅠㅠ
        return jsonify({'message': '지금은 3학년만 신청이 가능한 시간입니다. 11시 40분부터 이용해 주세요.'}), 403
    
    # 그룹 정보 큐에 추가
    q.append(body)

    # 3학년인지 검증
    if len(list(filter(lambda e: e/10000 == 3, body))) != len(body):
        
        return jsonify({'message': '추가적인 조건이 충족되지 않았습니다.'}), 403
    
    # 신청 성공!
    return jsonify({'message': '급식이 신청되었습니다.'})
    
# 급식 신청 시간 범위(11시 30분 ~ 11시 40분)
lunch_start_time = time(11, 30)  
lunch_end_time = time(11, 40)    

# 급식 신청 시간 함수
def check_lunch_time():
    now = datetime.now()  
    current_time = now.time()  
    return lunch_start_time <= current_time <= lunch_end_time

# 실행
if __name__ == "__main__":
    app.run()
