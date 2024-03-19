from quart import Blueprint, request, jsonify, Response

from util.seat_manager import SeatManager
from util.json_util import read_json
from util.database import DatabaseUtil

seat_bp = Blueprint('seat', __name__)
seat_manager = SeatManager()

__db_config = read_json("../config/database.json")
db_util = DatabaseUtil(
    host=__db_config['host'],
    password=__db_config['password']
)


# TODO: 테스트

@seat_bp.route('/enter', methods=['POST'])
async def seat_enter():
    """
    학생 입장 시 이 경로로 POST 요청 전송
    요청 본문

    * 학생의 학번
    """
    try:
        student_id: int = await request.json
        entered_user_group_index: int = db_util.query(
            "SELECT group_status FROM students WHERE student_id=%(student_id)s",
            student_id=student_id
        ).result[0][0]

        seat_manager.enter_student(student_id)
        if entered_user_group_index > 2:  # 부정 입장 처리
            db_util.query(
                "UPDATE students SET cheat_count=cheat_count+1 WHERE student_id=%(student_id)s",
                student_id=student_id
            )

        if seat_manager.seat_remain >= len(seat_manager.group[0].members):
            seat_manager.enter_next_group()

        return jsonify(student_id), 200

    except Exception as e:
        return jsonify({ 'error': str(e) }), 500


@seat_bp.route('/exit', methods=['POST'])
async def seat_exit():
    """
    학생 퇴장 시 이 경로로 POST 요청 전송
    """
    try:
        student_id: int = await request.json

        seat_manager.exit_student(student_id)
        return Response(status=204)

    except Exception as e:
        return jsonify({ "error": str(e) }), 500


@seat_bp.route('/remain', methods=['GET'])
async def seat_remain():
    """
    현재 남은 좌석 수 반환
    """
    return jsonify(seat_manager.seat_remain), 200
