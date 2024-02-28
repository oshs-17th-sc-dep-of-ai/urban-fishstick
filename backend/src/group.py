from quart import Blueprint, request, jsonify, make_response

import sseclient
import asyncio

from util.sse_helper import ServerSentEvent
from util.seat_manager import SeatManager

bp = Blueprint('group', __name__)
seat_manager = SeatManager()

students_db = {
    10001: { 'group_state': None },
    10002: { 'group_state': None },
    10003: { 'group_state': None },
    10004: { 'group_state': None },
}


@bp.route('/register', methods=['POST'])
async def group_register():
    try:
        data = await request.json
        group_members = data.get('group_members', [])
        group_id = group_members[0]

        for student_id in group_members:
            if student_id not in students_db:
                return jsonify({ 'error': f'ID {student_id} not found' }), 404

            if students_db[student_id]['group_state'] is not None:
                return jsonify({ 'error': f'ID {student_id} already belongs to group' }), 403

            students_db[student_id]['group_state'] = group_id

        seat_manager.register_group(group_members)
        seat_manager.id(group_id)
        return jsonify({ 'message': f' {group_members} register success' }), 200

    except Exception as e:
        return jsonify({ 'error': str(e) }), 500


@bp.route('/index', methods=['POST'])
async def group_index():
    try:
        student_id = int(await request.data)
        student_group_state = students_db[student_id]['group_state']

        if student_id not in students_db or student_group_state is None:
            return jsonify({ 'error': f'ID {student_id} does not belong to any group.' }), 404

        if student_group_state not in seat_manager.group_ids:
            return jsonify({ 'error': f'ID {student_id} unapplied student' }), 404

        return jsonify({ 'group_index': seat_manager.group_ids.index(student_group_state) }), 200

    except Exception as e:
        return jsonify({ 'error': str(e) }), 500


@bp.route('/index/sse', methods=['GET'])
async def group_index_sse(student_id):
    if "text/event-stream" not in request.accept_mimetypes:
        return jsonify({ "error": "this route requires event stream" }), 400

    async def send_events():
        while seat_manager.group_ids.index(students_db[student_id]['group_state']) > 5:
            data = seat_manager.group_ids.index(students_db[student_id]['group_state'])
            event = ServerSentEvent(data)
            await asyncio.sleep(30)  # 30초 대기

            yield event.encode()

    response = await make_response(send_events(), {
        "Content-Type": "text/event-stream",
        "Cache-Control": "no-cache",
        "Transfer-Encoding": "chunked"
    })
    response.timeout = None

    return response


@bp.route('/check', methods=['POST'])
async def group_check():
    try:
        data = await request.json
        group_members = data.get('group_members', [])

        duplicate = [student_id for student_id in group_members if student_id in seat_manager.group]

        if duplicate:
            return jsonify({ 'error': f'Duplicate Student ID : {duplicate}' }), 403

        return jsonify({ 'message': 'No duplicates' }), 200

    except Exception as e:
        return jsonify({ 'error': str(e) }), 500
