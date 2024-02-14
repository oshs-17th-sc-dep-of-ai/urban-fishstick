from flask import Flask, Blueprint, request, jsonify

exit_blueprint = Blueprint("exit", __name__)

group = []

# 퇴장
@exit_blueprint.route("/exit", methods=["POST"])
def exit():
    try:
        student_id = request.data.decode("utf-8")

        if student_id in group:
            group.remove(student_id)
            return jsonify({"message": "퇴장 처리 완료"}), 200
        else:
            return jsonify({"message": "해당 학생이 그룹에 존재하지 않습니다."}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 500
