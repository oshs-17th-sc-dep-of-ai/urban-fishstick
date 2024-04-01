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


@prior_bp.route("/check", methods=["GET"])
async def prior_check():
    """
    쿼리 스트링 키
    id: 학번
    """
    try:
        qs_id = request.args.get("student_id")

        if not qs_id:
            return jsonify({ "error": "query string must contain valid id" }), 400

        query = db_util.query(
            "SELECT prior_key FROM students WHERE student_id=%(student_id)s AND prior_key IS NOT NULL",
            student_id=qs_id
        )
        if query.affected_rows > 0:
            return Response(status=200)
        else:
            return Response(status=404)

    except Exception as e:
        return jsonify({ "error": str(e) }), 500
        # return Response(status=500)  # 배포 시 코드


@prior_bp.route("/register", methods=["POST"])
async def prior_register():
    try:
        req = await request.json

        # SHA-1 이용
        # 발급 교사 ID + 인증 키 + 학번
        # SELECT SHA1(CONCAT(%s, %s, %s), 256);

        sql = ("UPDATE students "
               "SET    prior_key=SHA1(CONCAT(%(teacher_id)s, '-', %(validation_code)s, '-', %(student_id)s)) "
               "WHERE  student_id IN ("
               "    SELECT student_id FROM teachers, students "
               "    WHERE teachers.teacher_id=%(teacher_id)s AND "
               "          teachers.validation_key=%(validation_code)s AND "
               "          students.student_id=%(student_id)s"
               ")")

        db_util.query_many(sql, req)
        db_util.commit()

        return jsonify({ "result": "OK" }), 201
    except Exception as e:
        return jsonify({ "error": e }), 500
        # return Response(status=500)  # 배포 시 코드
