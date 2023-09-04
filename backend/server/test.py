from flask import Blueprint, jsonify, Flask
import datetime
import deque

req_time = datetime.datetime.now()
current_hour = req_time.strftime("%H")
current_min = req_time.strftime("%M")
print(current_hour,current_min)
third_grade_time = ["30","31","32","33","34","35","36","37","38","39"]
success = True # bool

school_number = [20101] # list
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
        "waiting" : index
    }

print(response_data)
