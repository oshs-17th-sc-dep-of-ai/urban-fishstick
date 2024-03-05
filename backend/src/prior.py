from quart import Blueprint, request, jsonify
from util.seat_manager import SeatManager

prior_bp = Blueprint('prior', __name__)
seat_manager = SeatManager()


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
        data = await request.get_json()

        group_members = data.get('group_members', [])
        auth_key = data.get('key', None)
        key = "some"
        if auth_key in data:
            if auth_key != key:
                return jsonify({ 'error': 'Incorrect authentication key' }), 403
            else:
                return jsonify({ 'key': auth_key, 'group_members': group_members }), 200
        else:
            seat_manager.entered_people -= len(group_members)
            return jsonify("test"), 204

    except Exception as e:
        return jsonify({ 'error': str(e) }), 500
