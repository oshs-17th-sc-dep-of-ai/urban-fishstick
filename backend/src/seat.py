from quart import Blueprint, request, jsonify
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
            return jsonify({'error': f'ID가 {non_existing_students}인 학생을 찾을 수 없습니다'}), 404

        return jsonify(group_members), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500


@bp.route('/exit', methods=['POST'])
async def seat_exit():
    try:
        student_id = int(await request.data)
        return jsonify(student_id), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500


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
            return jsonify({'error': '인증 키가 올바르지 않습니다'}), 403

        return jsonify({'key': auth_key, 'group_members': group_members}), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500
