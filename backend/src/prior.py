from quart import Blueprint, Response, request, jsonify

from util.json_util import read_json
from util.database import DatabaseUtil
from util.seat_manager import SeatManager

__db_config = read_json("../config/database.json")

prior_bp = Blueprint('prior', __name__)
seat_manager = SeatManager()
db_util = DatabaseUtil(
    host=__db_config['host'],
    password=__db_config['password']
)


# TODO: 테스트

@prior_bp.route("/exit", methods=["POST"])
async def prior_exit():
    try:
        student_id = await request.json

        exists = db_util.query("DELETE FROM prior_students WHERE student_id=%(student_id)s", student_id=student_id)
        if exists:
            seat_manager.seat_remain += 1
            return jsonify({ "message": "OK" }), 200
        else:
            return jsonify({ "message": "Cannot find student in prior group" }), 404

    except Exception as e:
        return jsonify({ "error": str(e) }), 500
        # return Response(status=500)  # 배포 시 코드


@prior_bp.route("/check", methods=["GET"])
async def prior_check():
    """
    쿼리 스트링 키
    id: 학번
    """
    try:
        qs_id = request.args.get("id")
        qs_key = request.args.get("key")

        if not qs_id:
            return jsonify({ "error": "query string must contain valid id" }), 400

        query = db_util.query(
            "SELECT student_id FROM prior_students WHERE student_id=%(student_id)s AND validation_key=%(key)s",
            student_id=qs_id,
            key=qs_key
        )
        if query.result[0]:
            return jsonify({ "result": "valid" }), 200
        else:
            return jsonify({ "result": "invalid" }), 404

    except Exception as e:
        return jsonify({ "error": str(e) }), 500
        # return Response(status=500)  # 배포 시 코드


@prior_bp.route("/enter", methods=["POST"])
async def prior_enter():
    try:
        data = await request.json

        student_id = data["student_id"]
        srv_auth_key_query = db_util.query(
            "SELECT student_id FROM prior_students WHERE student_id=%(student_id)s",
            student_id=student_id
        )
        try:
            srv_auth_key_query.result[0]
        except IndexError:
            return jsonify({ "error": "Student not found" }), 404

        seat_manager.entered_students -= 1
        return jsonify("test"), 204

    except Exception as e:
        return jsonify({ "error": str(e) }), 500
        # return Response(status=500)  # 배포 시 코드


@prior_bp.route("/register", methods=["POST"])
async def prior_register():
    # WIP
    req = await request.json
    # sql    = ("INSERT INTO prior_students (student_id, author, validation_key) " +
    #           "SELECT %s, SHA1(%s), %s" +
    #           "FROM DUAL WHERE EXISTS (SELECT teacher_id FROM teachers WHERE teacher_id=%s AND validation_key=%s)")
    # result = db_util.query_many(sql, req)

    # SHA-256 이용?
    # 학번 + 발급 교사 ID + 유효일
    # SELECT SHA2(CONCAT(%s, %s %s), 256);

    sql = ("UPDATE students "
           "SET prior_key=%s "
           "WHERE student_id IN ("
           "    SELECT * FROM teachers, students "
           "    WHERE teachers.teacher_id=%s AND "
           "          teachers.validation_key=%s AND "
           "          students.student_id=%s"
           ")")

    return Response(status=204)
