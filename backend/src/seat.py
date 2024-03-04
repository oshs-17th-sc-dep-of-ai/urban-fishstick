from quart import Blueprint, request, jsonify
from .main import seat_manager

bp = Blueprint('seat', __name__)

students_db = {
    10001: { 'group_state': None },
    10002: { 'group_state': None },
    10003: { 'group_state': None },  # 어떤 그룹에도 속해 있지 않음
}


@bp.route('/enter', methods=['POST'])
async def seat_enter():
    """
    학생 입장 시 이 경로로 POST 요청 전송
    요청 본문

    * 학생의 학번
    """
    try:
        student_id: int = await request.json

        seat_manager.enter_student(student_id)

        if seat_manager.seat_remain >= len(seat_manager.group[0].members):
            seat_manager.enter_next_group()

        return jsonify({ "entered": student_id }), 200

    except Exception as e:
        return jsonify({ 'error': str(e) }), 500


@bp.route('/exit', methods=['POST'])
async def seat_exit():
    """
    학생 퇴장 시 이 경로로 POST 요청 전송
    """
    try:
        student_id: int = await request.json

        seat_manager.exit_student(student_id)
        return jsonify({ "exited": student_id })

    except Exception as e:
        return jsonify({ "error": str(e) }), 500


@bp.route('/remain', methods=['GET'])
async def seat_remain():
    """
    현재 남은 좌석 수 반환
    """
    return jsonify(seat_manager.seat_remain), 200
