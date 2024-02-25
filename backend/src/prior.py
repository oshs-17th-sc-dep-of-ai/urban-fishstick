from quart import Blueprint, request, jsonify
from util.seat_manager import SeatManager

bp = Blueprint('prior', __name__)
seat_manager = SeatManager()

teacher_ids = set(["tid1", "tid2"])

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
