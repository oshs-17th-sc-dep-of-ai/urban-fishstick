from quart import Blueprint, request, jsonify
from util.seat_manager import SeatManager

bp = Blueprint('prior', __name__)
seat_manager = SeatManager()

teacher_ids = { "tid1", "tid2" }

@bp.route('/exit', methods=['POST'])
async def prior_exit():
    try:
        seat_manager.seat_remain += 1
        return jsonify({'message': 'Prior group exited successfully'}), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500

@bp.route('/check', methods=['GET'])
async def prior_check():
    try:
        teacher_id = request.args.get('tid')
        if teacher_id in teacher_ids:
            return '', 204
        else:
            return '', 404

    except Exception as e:
        return jsonify({'error': str(e)}), 500

@bp.route('/enter', methods=['POST'])
async def prior_enter():
    try:
        data = await request.get_json()

        group_members = data.get('group_members', [])
        auth_key = data.get('key', None)
        key = "some"
        if auth_key in data:
            if auth_key != key:
                return jsonify({'error': 'Incorrect authentication key'}), 403
            else:
                return jsonify({'key': auth_key, 'group_members': group_members}), 200
        else:
            return jsonify("test"), 204  # TODO: 교사일경우 그룹인원수 측정후 전체에서 뺴주는 기능 필요.

    except Exception as e:
        return jsonify({'error': str(e)}), 500