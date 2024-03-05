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

@prior_bp.route('/exit', methods=['POST'])
async def prior_exit():
    try:

        seat_manager.seat_remain += 1
        return jsonify({ 'message': 'Prior group exited successfully' }), 200

    except Exception as e:
        return jsonify({ 'error': str(e) }), 500


@prior_bp.route('/check', methods=['GET'])
async def prior_check():
    """
    쿼리 스트링 키
    type: teacher | student 값 중 하나
    id: type 키 값에 따라 달라짐, 학생의 경우 학번
    """
    qs_type = request.args.get('type')
    qs_id = request.args.get('id')

    try:
        if qs_type == "teacher":
            # teacher process
            return '', 204
        elif qs_type == "student":
            # student process
            return '', 204
        else:
            # if invalid type or id
            return jsonify({ "error": "query string must contain valid type and id" }), 400

    except Exception as e:
        return jsonify({ 'error': str(e) }), 500


@prior_bp.route('/enter', methods=['POST'])
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
            return jsonify({ 'error': 'Incorrect authentication key' }), 403
        else:
            seat_manager.entered_people -= 1
            return jsonify("test"), 204

    except Exception as e:
        return jsonify({ 'error': str(e) }), 500
