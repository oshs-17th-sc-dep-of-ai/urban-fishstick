from flask import Blueprint, Flask,jsonify
import routes import alarm, entered, exit, priority, suggestion
import util import deque

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