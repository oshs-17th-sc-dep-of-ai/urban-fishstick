from flask import Blueprint, jsonify, Flask
import deque

alarm_left_line = 5 # 대기줄 내려옴 알림
blueprint = Blueprint("alarm", __name__)

@blueprint.route('/', methods=["get"]) # codespace에서 예외파일 실행 안됨, 이후 url 변경 (url = /alarm)
def alarm():
    if len(deque.q) < alarm_left_line:
        alarm_left_line = len(deque.q)
    result = {
        "alar" : "come down",
        "group" : deque.q[alarm_left_line]
    }
    return jsonify(result)