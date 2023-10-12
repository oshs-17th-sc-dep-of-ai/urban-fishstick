from flask import Blueprint, Flask
import datetime
import deque,apply

def apply(num,apply):
    global school_number,success
    school_number = num
    success = apply

example_bp = Flask(__name__)
@example_bp.route('/', methods=["GET"])
def example_route():
    data = {
        "ID" : school_number,
    }

    user_id = data['ID']

    deque.apply_meal(user_id)

    apply = deque.apply_meal(user_id)
    index = deque.index(user_id)

    reason = {
        "grade" : "Cannot enter", # 10분 전 3학년 이하
        "input" : "Input error" # 입력 오류
    }

    if (success == False):
        response_data = {
            "successs" : False,
            "reason" : reason["input"]
        }
    else:
        response_data = {
            "success" : True,
            "waiting" : index,
            "school_number" : school_number,
            "come in" : deque.enter(1)
        }
    return response_data