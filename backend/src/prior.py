from quart import Blueprint, request, jsonify

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
            return jsonify({ "message": "Student exited successfully" }), 200
        else:
            return jsonify({ "message": "Cannot find student in prior group" }), 404

    except Exception as e:
        return jsonify({ "error": str(e) }), 500


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
        req_auth_key = data["key"]
        srv_auth_key_query = db_util.query(
            "SELECT validation_key FROM prior_students WHERE student_id=%(student_id)s",
            student_id=student_id
        )

        print(srv_auth_key_query)

        if not srv_auth_key_query.affected_rows or req_auth_key != srv_auth_key_query.result:
            return jsonify({ "error": "Incorrect authentication key" }), 403
        else:
            seat_manager.entered_people -= 1
            return jsonify("test"), 204

    except Exception as e:
        return jsonify({ "error": str(e) }), 500
        # return Response(status=500)  # 배포 시 코드


@prior_bp.route("/register", methods=["POST"])
async def prior_register():
    # WIP
    req = await request.json
    sql = ("INSERT INTO prior_students(student_id, validation_key, author) VALUES (%s, SHA1(%s), %s)" +
           ", (%s, SHA1(%s))" * (len(req) - 2))

    print(req, sql)

    # query = db_util.query_many(sql, req)
    # if query.result:
    #     return jsonify({ "result": "OK" }), 201
    # else:
    #     return jsonify({ "result": "FAILED" }), 403
    return jsonify("test"), 201
