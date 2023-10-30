from flask import Flask, request, jsonify, Blueprint
import pymysql

app = Flask(__name__)

# MySQL 연결 설정
db = pymysql.connect(
    host="localhost",
    user="username",
    password="password",
    database="database_name",
    cursorclass=pymysql.cursors.DictCursor
)

suggestion_bp = Blueprint('suggestion', __name__)

@suggestion_bp.route('/add', methods=['POST'])
def add_suggestion():
    data = request.get_json()  # 전송된 JSON 데이터
    title = data['title']
    id = data['id']
    body = data['body']

    cursor = db.cursor()
    cursor.execute("INSERT INTO some_table (title, id, body) VALUES (?, ?, ?)", (title, id, body))
    db.commit()
    return jsonify({'message': '건의사항이 성공적으로 수렴되었습니다.'})

@suggestion_bp.route('/get', methods=['GET'])
def get_suggestion():
    cursor = db.cursor()
    cursor.execute("SELECT title, body FROM some_table")
    results = cursor.fetchall()
    suggestion_list = []

    for result in results:
        suggestion_dict = {'title': result['title'], 'body': result['body']}
        suggestion_list.append(suggestion_dict)

    return jsonify(suggestion_list)

if __name__ == '__main__':
    app.register_blueprint(suggestion_bp, url_prefix='/suggestion')
    app.run(debug=True)
