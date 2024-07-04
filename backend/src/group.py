import asyncio
from typing import List

from quart import Blueprint, Response, request, jsonify, make_response

from util.json_util import read_json
from util.sse_helper import ServerSentEvent
from util.seat_manager import Group, SeatManager
from util.database import DatabaseUtil

__db_config = read_json("../config/database.json")

group_bp = Blueprint('group', __name__)
seat_manager = SeatManager()
db_util = DatabaseUtil(
    host=__db_config['host'],
    password=__db_config['password']
)


@group_bp.route('/register', methods=['POST'])
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
        print(request.headers)
        print(await request.body)

        group_members: List[int] = await request.json
        filtered_students: List[int] = sum(list(map(list, db_util.query(
            "SELECT student_id FROM students WHERE student_id IN %(group)s AND group_status IS NULL",
            group=group_members
        ).result)), [])

        assert bool(filtered_students)

        group_id: int = hash(tuple(filtered_students))
        affected: int = db_util.query(
            "UPDATE students "
            "SET group_status=SHA1(%(group_id)s) WHERE student_id IN %(group_members)s",
            group_id=group_id,
            group_members=filtered_students
        ).affected_rows
        db_util.commit()

        seat_manager.register_group(filtered_students)
        try:
            if seat_manager.seat_remain >= len(seat_manager.group[0].members):
                seat_manager.enter_next_group()
        except IndexError:
            pass

        return jsonify({
            "message": "register success",
            "affected_students_count": affected,
            "members": filtered_students,
            "group_id": db_util.query(
                "SELECT SHA1(%(group_id)s) FROM dual",
                group_id=group_id
            ).result[0][0]
        }), 200
    except AssertionError:
        return jsonify({
            "message": "register failed",
        }), 400
    except Exception as e:
        print(e)
        return jsonify({ "error": str(e) }), 500


@group_bp.route('/index', methods=['GET'])
async def group_index():
    try:
        print(request.args)
        if not request.args.get("sid").isdecimal():
            return jsonify({ "error": "Invalid student ID" }), 400

        student_id = int(request.args.get("sid"))
        search_result: Group = list(filter(lambda g: student_id in g.members, seat_manager.group))[0]
        _group_index: int = seat_manager.group.index(search_result)

        return jsonify(_group_index), 200
    except IndexError:
        return jsonify(None), 404
    except Exception as e:
        print(e)
        return jsonify({ 'error': str(e) }), 500
        # return Response(status=500)  # 배포 시 코드


@group_bp.route("/index/sse", methods=['GET'])
async def group_index_sse():
    try:
        if "text/event-stream" not in request.accept_mimetypes:
            return jsonify({ "error": "this route requires event stream" }), 400
        if request.args.get("sid") is None or not request.args.get("sid").isdecimal():
            return jsonify({ "error": "Invalid student ID" }), 400

        student_id: int = int(request.args.get("sid"))

        async def send_events():
            try:
                search_result: Group = list(filter(lambda g: student_id in g.members, seat_manager.group))[0]
                _group_index: int = seat_manager.group.index(search_result)

                while _group_index >= 5:
                    event = ServerSentEvent(str(_group_index))
                    await asyncio.sleep(30)

                    yield event.encode()
            except IndexError:
                yield ServerSentEvent("0").encode()

        response = await make_response(send_events(), {
            "Content-Type": "text/event-stream",
            "Cache-Control": "no-cache",
            "Transfer-Encoding": "chunked"
        })
        response.timeout = None

        return response
    except IndexError:
        return jsonify(None), 404
    except Exception as E:
        print(E)
        return Response(status=500)  # 배포 시 코드


@group_bp.route('/check', methods=['GET'])
async def group_check():
    try:
        # 쿼리 스트링 포맷:
        #   키: students
        #   값: '-'로 이어진 학번 리스트
        #   ex) 10000-10001-10002
        group_members: List[int] = list(map(int, request.args.get("students").split('-')))

        query = db_util.query(
            "SELECT student_id FROM students WHERE student_id IN %(members)s AND group_status IS NOT NULL",
            members=group_members
        )
        duplicate = [_e[0] for _e in query.result]
        affected = query.affected_rows
        return jsonify({ "affected_rows": affected, "result": duplicate }), 200

    except Exception as e:
        return jsonify({ 'error': str(e) }), 500
        # return Response(status=500)  # 배포 시 코드


@group_bp.route("/check_user", methods=["GET"])
async def check_user():
    """
    클라이언트에서는 학번과 학생 코드를 같이 입력하도록 해야 하며,
    결과 값 확인 후 사용할 수 있도록 개발 필요
    """
    try:
        assert request.args.get("code") is not None
        assert request.args.get("id") is not None

        code = request.args.get("code")
        query = db_util.query(
            "SELECT student_code FROM students WHERE student_id=%(student_id)s",
            student_id=request.args.get("id")
        ).result[0][0]

        return jsonify({ "result": "correct" if query == code else "incorrect" }), 200
    except AssertionError:
        return jsonify({ "error": "query string required: (id, code)" }), 400
    except Exception as e:
        return jsonify({ "error": str(e) }), 500
        # return Response(status=500)  # 배포 시 코드
