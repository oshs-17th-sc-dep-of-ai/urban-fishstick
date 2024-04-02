from quart import Blueprint, request, jsonify, Response

from util.seat_manager import SeatManager
from util.json_util import read_json
from util.database import DatabaseUtil

seat_bp = Blueprint('seat', __name__)
seat_manager = SeatManager()

__db_config = read_json("../config/database.json")
db_util = DatabaseUtil(
    host=__db_config['host'],
    password=__db_config['password']
)


@seat_bp.route('/enter', methods=['POST'])
async def seat_enter():
    """
    학생 입장 시 이 경로로 POST 요청 전송
    요청 본문

    * 학생의 학번
    """
    try:
        student_id: int = await request.json

        seat_manager.enter_student(student_id)
        try:
            if student_id not in seat_manager.group[0].members:  # 부정 입장, 우선 급식 처리
                db_util.query(
                    "UPDATE students "  # TODO: 테스트 필요
                    "SET cheat_count=cheat_count+1, group_status=NULL "
                    "WHERE student_id=%(student_id)s AND prior_key IS NULL",  # 부정 입장 시
                    student_id=student_id
                )
                db_util.query(  # TODO: 테스트 필요
                    "UPDATE students SET prior_key=NULL WHERE student_id=%(student_id)s",  # 사용한 키 삭제
                    student_id=student_id
                )
                db_util.commit()

            if seat_manager.seat_remain >= len(seat_manager.group[0].members):
                seat_manager.enter_next_group()

        except IndexError:
            db_util.query(
                "UPDATE students "  # TODO: 테스트 필요
                "SET cheat_count=cheat_count+1, group_status=NULL "
                "WHERE student_id=%(student_id)s AND prior_key IS NULL",  # 부정 입장 시
                student_id=student_id
            )
            db_util.query(  # TODO: 테스트 필요
                "UPDATE students SET prior_key=NULL WHERE student_id=%(student_id)s",  # 사용한 키 삭제
                student_id=student_id
            )
            db_util.commit()

        return jsonify(student_id), 200
    except Exception as e:
        return jsonify({ 'error': str(e) }), 500
        # return Response(status=500)  # 배포 시 코드


@seat_bp.route('/exit', methods=['POST'])
async def seat_exit():
    """
    학생 퇴장 시 이 경로로 POST 요청 전송
    """
    try:
        student_id: int = await request.json

        seat_manager.exit(student_id)

        if seat_manager.seat_remain >= len(seat_manager.group[0].members):
            seat_manager.enter_next_group()

        return Response(status=204)
    except Exception as e:
        return jsonify({ "error": str(e) }), 500
        # return Response(status=500)  # 배포 시 코드


@seat_bp.route('/remain', methods=['GET'])
async def seat_remain():
    """
    현재 남은 좌석 수 반환
    """
    return jsonify(seat_manager.seat_remain), 200


@seat_bp.route("/debug", methods=['GET'])
async def seat_debug():
    # TODO: 베타 시작 시 제거
    print("--------------------------------")
    print(f"seat remain: {seat_manager.seat_remain}")
    print(f"group list : {seat_manager.group}")
    print(f"entered    : {seat_manager.entered_students}")
    print("--------------------------------")
    return Response(status=204)
