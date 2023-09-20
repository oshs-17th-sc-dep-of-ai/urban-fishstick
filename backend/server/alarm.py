from flask import Blueprint, jsonify, Flask
import deque
ALARM_LEFT_LINE =5 # 대기줄 내려옴 알림
example_bp = Flask(__name__)
@example_bp.route('/', methods=["get"]) # codespace에서 예외파일 실행 안됨, 이후 url 변경 (url = /alarm)
def alarm():
    result = {
        "alar" : "come down",
        "group" : deque.q[ALARM_LEFT_LINE]
    }
    return result