from quart import Blueprint, request, jsonify
from util.seat_manager import SeatManager

bp = Blueprint('group', __name__)
seat_manager = SeatManager()

students_db = {
    10001: {'group_state': None},
    10002: {'group_state': None},
    10003: {'group_state': None},
}

@bp.route('/register', methods=['POST'])
async def group_register():
    try:
        data = await request.json
        group_members = data.get('group_members', [])

        for student_id in group_members:
            if student_id not in students_db:
                return jsonify({'error': f'ID가 {student_id}인 학생을 찾을 수 없습니다'}), 404

            if students_db[student_id]['group_state'] is not None:
                return jsonify({'error': f'ID가 {student_id}인 학생은 이미 그룹에 속해 있습니다'}), 403

        seat_manager.register_group(group_members)

        return jsonify({'message': '그룹 등록이 성공적으로 처리되었습니다'}), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500

@bp.route('/index', methods=['POST'])
async def group_index():
    try:
        student_id = int(await request.data)
        student_group_state = students_db[student_id]['group_state']

        if student_id not in students_db or student_group_state is None:
            return jsonify({'error': f'ID가 {student_id}인 학생은 그룹에 속해 있지 않습니다'}), 404

        if student_group_state not in seat_manager.group:
            return jsonify({'error': f'ID가 {student_id}인 학생은 미신청 학생입니다'}), 404
        
        return jsonify({'group_index': seat_manager.group.index(student_group_state)}), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500

@bp.route('/check', methods=['POST'])
async def group_check():
    try:
        data = await request.json
        group_members = data.get('group_members', [])

        duplicate = [student_id for student_id in group_members if student_id in seat_manager.group]

        if duplicate:
            return jsonify({'error': f'중복되는 학생이 있습니다: {duplicate}'}), 403
        
        return jsonify({'message': '중복되는 학생이 없습니다'}), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500

