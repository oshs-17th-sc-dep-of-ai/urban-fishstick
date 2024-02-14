from quart import Blueprint, request, jsonify, Quart
from util.seat_manager import SeatManager  # SeatManager 클래스 import

bp = Blueprint('seat', __name__)
seat_manager = SeatManager()

students_db = {
    10001: {'group_state': None},
    10002: {'group_state': None},
    10003: {'group_state': None},  # 어떤 그룹에도 속해 있지 않음
}

@bp.route('/enter', methods=['POST'])
async def seat_enter():
    try:
        data = await request.json
        group_members = data.get('group_members', [])

        non_existing_students = [student_id for student_id in group_members if student_id not in students_db]

        if non_existing_students:
            return jsonify({'error': f'ID {non_existing_students} not found'}), 404

        seat_manager.seat_remain -= len(group_members)
        return jsonify(group_members), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500

@bp.route('/exit', methods=['POST'])
async def seat_exit():
    try:
        student_id = int(request.data.decode("utf-8"))

        if student_id in seat_manager.group:
            seat_manager.seat_remain += 1
            return jsonify({"message": "퇴장 처리 완료"}), 200
        else:
            return jsonify({"message": "해당 학생이 그룹에 존재하지 않습니다."}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@bp.route('/remain', methods=['GET'])
async def seat_remain():
    return jsonify(seat_manager.seat_remain)

@bp.route('/enter/prior', methods=['POST'])
async def seat_enter_prior():
    try:
        data = await request.json
        group_members = data.get('group_members', [])
        auth_key = data.get('key', None)
        key = "some"

        if auth_key != key:
            return jsonify({'error': 'Incorrect authentication key'}), 403

        return jsonify({'key': auth_key, 'group_members': group_members}), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500