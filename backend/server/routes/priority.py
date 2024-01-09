# main.py
from flask import Flask, jsonify
import apply

blueprint = Blueprint(__name__)

space_available = 5  # 초기 공간 상태 (예시로 5로 설정)

# 우선 급식 발생
def priority_meal_occurred():
    global space_available, apply
    if space_available > 0:
        space_available -= 1
    else:
        apply.q.append("priority")

# 여유 공간 확인
def check_space():
    global space_available, apply
    if space_available > 0 and apply.q:
        space_available -= 1
        apply.q.pop(0)  # 첫 번째 그룹 입장

@blueprint.route('/', methods=["GET"])
def example_route():
    result = {
        "space_available": space_available,
        "group_queue": list(apply.q)
    }
    return jsonify(result)
