# main.py
from flask import Flask, jsonify
import deque

app = Flask(__name__)

space_available = 5  # 초기 여유 공간 상태 (예시로 5로 설정)

# 우선 급식 발생
def priority_meal_occurred():
    global space_available
    if space_available > 0:
        space_available -= 1
        deque.q.appendleft("priority")

@app.route('/', methods=["GET"])
def space():
    result = {
        "space_available": space_available,
        "group_queue": list(deque.q)
    }
    return jsonify(result)
