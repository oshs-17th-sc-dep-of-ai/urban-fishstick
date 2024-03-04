from typing import List

from quart import Blueprint, request, jsonify, make_response

import asyncio

from main import seat_manager, db_conn as db
from util.sse_helper import ServerSentEvent
from util.seat_manager import Group

bp = Blueprint('group', __name__)


@bp.route('/register', methods=['POST'])
async def group_register():
    """
    그룹을 입장 큐에 추가\n
    요청 본문

    - 정수 리스트 (학번으로 구성됨)

    성공 시 응답 본문

    - message: 응답 성공 메세지
    - affected_students_count: 등록에 성공한 학생 수
    - group_id: 큐 내에서의 그룹 아이디

    실패 시 응답 본문

    - error: 서버 오류
    """
    try:
        with db.cursor() as cursor:
            data = await request.json
            group_members = data.get('group_members', [])
            group_id = seat_manager.register_group(group_members)
            affected = cursor.executemany(
                "UPDATE students SET group_status=? WHERE student_id=? AND group_status IS NULL",
                group_id,
                group_members
            )
            db.commit()

            if seat_manager.seat_remain >= len(seat_manager.group[0].members):
                seat_manager.enter_next_group()

            return jsonify({
                "message": "register success",
                "affected_students_count": affected,
                "group_id": group_id
            }), 200

    except Exception as e:
        return jsonify({ "error": str(e) }), 500


@bp.route('/index', methods=['GET'])
async def group_index():
    try:
        cursor = db.cursor()
        # TODO: 쿼리 스트링으로 변경
        # student_id = int(await request.data)
        # cursor.execute("SELECT group_status FROM students WHERE student_id=?", student_id)
        student_group_status = await cursor.fetchone()  # TODO: 데이터 타입 확인

        if student_group_status is None:
            return jsonify({ "index": -1 }), 404
        else:
            return jsonify({ "index": student_group_status }), 200

    except Exception as e:
        return jsonify({ 'error': str(e) }), 500


@bp.route('/index/sse', methods=['GET'])
async def group_index_sse():
    if "text/event-stream" not in request.accept_mimetypes:
        return jsonify({ "error": "this route requires event stream" }), 400
    if not request.args.get("sid").isdecimal():
        return jsonify({ "error": "Invalid student ID" }), 400

    student_id: int = int(request.args.get("sid"))

    async def send_events():
        search_result: Group = list(filter(lambda g: student_id in g.members, seat_manager.group))[0]
        _group_index: int = seat_manager.group.index(search_result)

        while _group_index >= 5:
            event = ServerSentEvent(str(_group_index))
            await asyncio.sleep(30)

            yield event.encode()

    response = await make_response(send_events(), {
        "Content-Type": "text/event-stream",
        "Cache-Control": "no-cache",
        "Transfer-Encoding": "chunked"
    })
    response.timeout = None

    return response


@bp.route('/check', methods=['GET'])
async def group_check():
    try:
        cursor = db.cursor()
        group_members: List[int] = list(map(int, request.args.get("student").split()))
        # 쿼리 스트링 포맷:
        #   키: student
        #   값: '-'로 이어진 학번 리스트
        #   ex) 10000-10001-10002

        cursor.execute("SELECT student_id FROM students WHERE student_id IN %(members)s AND group_status IS NOT NULL",
                       { "members": group_members })
        duplicate = cursor.fetchall()
        return jsonify({ "duplicate_students": duplicate }), 200

    except Exception as e:
        return jsonify({ 'error': str(e) }), 500
