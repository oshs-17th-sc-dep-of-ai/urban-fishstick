from quart import Blueprint, request, jsonify

bp = Blueprint('seat', __name__)

# 샘플 데이터베이스
students_db = {
    10001: {'group_state': None},
    10002: {'group_state': None},
    10003: {'group_state': None},
}

class SeatManager:
    def __init__(self):
        self.entrance_order = []

    def add_student(self, student_id):
        self.entrance_order.append(student_id)

    def get_entrance_order(self):
        return self.entrance_order

seat_manager = SeatManager()

# /seat/enter 그룹 입장 처리
@bp.route('/enter', methods=['POST'])
async def seat_enter():
    try:
        data = await request.json
        group_members = data.get('group_members', []) # 키가 존재하지 않을 경우 빈 리스트

        for student_id in group_members:
            # 학생이 데이터베이스에 존재하는지 확인
            if student_id not in students_db:
                return jsonify({'error': f'ID가 {student_id}인 학생을 찾을 수 없습니다'}), 404

            # 학생이 이미 다른 그룹에 속해 있는지 확인
            if students_db[student_id]['group_state'] is not None:
                return jsonify({'error': f'ID가 {student_id}인 학생은 이미 그룹에 속해 있습니다'}), 400

        # 모든 학생을 그룹에 입장시킴
        for student_id in group_members:
            students_db[student_id]['group_state'] = 'entered'
            seat_manager.add_student(student_id)

        return jsonify({'message': '그룹 입장이 성공적으로 처리되었습니다'}), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500

# /seat/exit 엔드포인트 - 그룹 퇴장 처리
@bp.route('/exit', methods=['POST'])
async def seat_exit():
    try:
        student_id = int(await request.data)

        # 학생이 데이터베이스에 존재하고, 그룹에 속해 있는지 확인
        if student_id not in students_db or students_db[student_id]['group_state'] is None:
            return jsonify({'error': f'ID가 {student_id}인 학생은 그룹에 속해 있지 않습니다'}), 400

        # 학생을 그룹에서 퇴장시킴
        students_db[student_id]['group_state'] = None

        return jsonify({'message': f'ID가 {student_id}인 학생이 성공적으로 퇴장했습니다'}), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500

# /seat/remain 엔드포인트 - 남은 좌석 확인
@bp.route('/remain', methods=['GET'])
async def seat_remain():
    return jsonify({'remaining_seats': 100})  # 실제 남은 좌석 수로 교체

# /seat/enter/prior 엔드포인트 - 입장 우선순위 처리
@bp.route('/enter/prior', methods=['POST'])
async def seat_enter_prior():
    try:
        data = await request.json
        group_members = data.get('group_members', [])
        auth_key = data.get('auth_key', '')

        # 입장 우선순위 로직 구현

        return jsonify({'message': '입장 우선순위가 성공적으로 처리되었습니다'}), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500
