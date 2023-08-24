from flask import Blueprint, jsonify, Flask
import deque

example_bp = Flask(__name__)
profile = Blueprint("profile", __name__)
example_bp.register_blueprint(profile, url_prefix='/profile')
@example_bp.route('/', methods=["GET"])
def example_route():
    학번 = 20820 # int
    확인 = True # bool
    data = {
        "ID" : 학번,
        "check" : 확인
    }

    user_id = data['ID']
    check_value = data['check']

    deque.apply_meal(user_id)

    if check_value:
        apply = deque.apply_meal(user_id)
        index = deque.index(user_id)
    response_data = {apply:index}
    return response_data
if __name__ == '__main__':
    example_bp.run(debug=True)
