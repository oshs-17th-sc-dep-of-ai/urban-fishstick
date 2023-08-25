from flask import Blueprint, jsonify, Flask
import deque

example_bp = Flask(__name__)
profile = Blueprint("profile", __name__)
example_bp.register_blueprint(profile, url_prefix='/profile')
@example_bp.route('/', methods=["GET"])
def example_route():
    success = False
    reason = "<Input error>"
    학번 = 20820 # int
    data = {
        "ID" : 학번,
    }

    user_id = data['ID']

    deque.apply_meal(user_id)

    apply = deque.apply_meal(user_id)
    index = deque.index(user_id)
    if success:
        response_data = {
            "success" : True,
            "waiting" : index
                        }
    else:
        response_data = {
            "success" : False,
            "reason" : reason
        }
    return response_data
if __name__ == '__main__':
    example_bp.run(debug=True)
