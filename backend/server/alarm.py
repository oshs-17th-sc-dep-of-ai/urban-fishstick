from flask import Blueprint, jsonify, Flask
import deque

example_bp = Flask(__name__)
profile = Blueprint("profile", __name__)
example_bp.register_blueprint(profile, url_prefix='/profile')
@example_bp.route('/', methods=["get"]) # codespace에서 예외파일 실행 안됨, 이후 url 변경 (url = /alarm)
def alarm():
    result = {
        "alar" : "!!!!",
        "group" : deque.q[0]
    }
    return result
if __name__ == '__main__':
    dq = deque.apply_meal([10517])
    returned_value = deque.enter([12312])
    example_bp.run(debug=True)
