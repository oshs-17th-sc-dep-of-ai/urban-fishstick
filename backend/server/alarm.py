from flask import Blueprint, jsonify, Flask
import deque

example_bp = Flask(__name__)
@example_bp.route('/', methods=["get"]) # codespace에서 예외파일 실행 안됨, 이후 url 변경 (url = /alarm)
def alarm():
    result = {
        "alar" : "!!!!",
        "group" : deque.q[0]
    }
    return result

dq = deque.apply_meal([10517])
ALARM_LEFT_LINE = 5 # 상수
if (deque.q.index([10517]) < ALARM_LEFT_LINE):
    returned_value = deque.enter([12312])
    example_bp.run(debug=True)
