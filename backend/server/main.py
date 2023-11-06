from flask import Blueprint, Flask,jsonify
import deque,entered,alarm,exit,priority,suggestion

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
    entered.push_applicant()

#입장 (줄에서 제거)
def enter():
    deque.enter(school_number)

#인덱스 (/index서버에 저장)
@main_bp.route('/index',methods=["POST"])
def index():
    return deque.index(school_number)


    

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
    return (response_data,alarm.alarm())

