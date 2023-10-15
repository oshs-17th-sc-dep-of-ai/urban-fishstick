from flask import Blueprint, jsonify, Flask
import deque
ALARM_LEFT_LINE = 5 # 대기줄 내려옴 알림
waiting = Flask(__name__)
@waiting.route('/', methods=["get"]) # codespace에서 예외파일 실행 안됨, 이후 url 변경 (url = /alarm)
def alarm():
    result = {
        "alar" : "come down",
        "group" : deque.q[0]
    }
    return jsonify(result)