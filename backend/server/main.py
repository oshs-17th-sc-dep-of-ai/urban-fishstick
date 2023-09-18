from flask import Blueprint, Flask
import datetime
import deque

def apply(num,apply):
    global school_number,success
    school_number = num
    success = apply

example_bp = Flask(__name__)
profile = Blueprint("profile", __name__)
example_bp.register_blueprint(profile, url_prefix='/profile')
@example_bp.route('/', methods=["GET"])
def example_route():
    req_time = datetime.datetime.now()
    current_hour = req_time.strftime("%H")
    current_min = req_time.strftime("%M")
    print(current_hour,current_min)
    third_grade_time = ["30","31","32","33","34","35","36","37","38","39"]
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
    
    if (data["ID"][0] < 30000 and current_hour == "11" and current_min in third_grade_time):
        response_data = {
            "success" : False,
            "reason" : reason["grade"]
        }
    elif (success == False):
        response_data = {
            "successs" : False,
            "reason" : reason["input"]
        }
    else:
        response_data = {
            "success" : True,
            "waiting" : index,
            "school_number" : school_number
        }
    return response_data