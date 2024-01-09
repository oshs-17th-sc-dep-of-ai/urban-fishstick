from flask import Blueprint, Flask,jsonify
from routes.alarm      import blueprint as alarm_bp
from routes.entered    import blueprint as enter_bp
from routes.priority   import blueprint as prior_bp
from routes.exit       import blueprint as exit_bp
from routes.suggestion import blueprint as sugg_bp

app = Flask(__name__)

app.register_blueprint(alarm_bp)
app.register_blueprint(enter_bp)
app.register_blueprint(prior_bp)
app.register_blueprint(exit_bp)
app.register_blueprint(sugg_bp)

"""
def apply(num,apply):
    global school_number,success
    school_number = num
    success = apply
    return school_number,success

main_bp = Flask(__name__)

#입장 알림
def enter_alarm():
    alarm.alarm()

#줄에 추가
def append_line():
    deque.apply_meal(school_number)

#3학년 확인
def third_grade():
    if (entered.check_lunch_time):
        entered.push_applicant()
        
#입장 (줄에서 제거)
def enter(school_number):
    deque.enter(school_number)

#인덱스 (/index서버에 저장)
@main_bp.route('/index',methods=["POST"])
def index():
    line = { deque.waiting : deque.index } # 대기인원중 자신이 몇번째인지
    return jsonify(line)

#건의사항 저장
def suggestion_add():
    suggestion.add_suggestion()

#건의사항 받아오기
def suggestion_get():
    return suggestion.get_suggestion()
#   나갈때 함수 (이후 구현)
#   def exit():
    # if not success:    
    #     response_data = { 
    #         "success" : False,
    #         "reason" : reason["input"]
    #         }
    # else:
    #     response_data = {
    #         "success" : True,
    #         # "waiting" : deque.waiting,
    #         "school_number" : school_number,
    #         "come in" : deque.enter(1)
    #     }
    # return (response_data,alarm.alarm()
'''
example_bp = Flask(__name__)
@example_bp.route('/', methods=["GET"])
def example_route():
    data = {
        "ID" : school_number
    }

    user_id = data['ID']

    deque.apply_meal(user_id)

    # apply = deque.apply_meal(user_id)
    # index = deque.index(user_id)

    reason = {
        "grade" : "Cannot enter", # 10분 전 3학년 이하
        "input" : "Input error" # 입력 오류
    }

    # 입력 오류 아닐시, 요청 여부와 학번, 
    if not success:    
        response_data = { 
            "success" : False,
            "reason" : reason["input"]
            }
    else:
        response_data = {
            "success" : True,
            # "waiting" : deque.waiting,
            "school_number" : school_number,
            "come in" : deque.enter(1)
        }
    return (response_data,alarm.alarm())'''
"""
