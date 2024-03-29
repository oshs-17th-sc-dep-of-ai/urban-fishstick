from quart import Blueprint, Response, request, jsonify
from util.json_util import read_json
import os

feedback_bp = Blueprint("feedback", __name__)
__server_config = read_json("../config/server.json")

# 건의사항 폴더 경로
folder = __server_config["feedback_data_dir"]  # 경로는 나중에 추가


# 건의사항 추가
@feedback_bp.route("/add", methods=["POST"])
async def add_feedback():
    try:
        text = await request.get_data(as_text=True)

        # 폴더가 없으면 폴더 생성
        if not os.path.exists(folder):
            os.makedirs(folder)

        # 파일 이름(feedback_1.txt ...)
        filename = f"feedback_{len(os.listdir(folder)) + 1}.txt"

        filepath = os.path.join(folder, filename)
        with open(filepath, "w") as file:
            file.write(text)

        return jsonify({ "message": "OK" }), 201

    except OSError:
        return jsonify({ "error": "Cannot write file" }), 500


# 건의사항 확인
@feedback_bp.route("/get/<filename>", methods=["GET"])
async def get_feedback(filename):
    try:
        filepath = os.path.join(folder, filename)

        with open(filepath, "r") as file:
            text = file.read()

        return text, 201
    except FileNotFoundError:
        return jsonify({ "error": "File not found" }), 404
    except:
        return Response(status=500)

