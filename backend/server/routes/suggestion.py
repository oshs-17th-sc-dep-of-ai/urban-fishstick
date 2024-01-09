from flask import Blueprint, request, jsonify
import pymysql

blueprint = Blueprint(__name__)

# MySQL 연결 설정
db = pymysql.connect(
    host="localhost",
    user="username",
    password="password",
    database="database_name",
    cursorclass=pymysql.cursors.DictCursor
)

@blueprint.route('/add_suggestion', methods=['POST'])
def add_suggestion():
        data = request.get_json() # 전송된 JSON 데이터
        title = data['title']
        id = data['id']

        cursor = db.cursor() # 객체 생성
        cursor.execute("INSERT INTO some_table (title, id) VALUES (%s, %s)", (title, id)) # 데이터 삽입
        db.commit()
        return jsonify({'message': '건의사항이 성공적으로 수렴되었습니다.'})

@blueprint.route('/get_suggestion', methods=['GET'])
def get_suggestion():
        cursor = db.cursor()
        cursor.execute("SELECT title FROM some_table")
        result = cursor.fetchone()
        if result:
            return jsonify(result)
        else:
            return jsonify({'message': '건의사항 없음'})
