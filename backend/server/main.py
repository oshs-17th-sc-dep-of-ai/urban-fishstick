from flask import Blueprint, jsonify, Flask
import deque

example_bp = Flask(__name__)
profile = Blueprint("profile", __name__)
example_bp.register_blueprint(profile, url_prefix='/profile')
@example_bp.route('/', methods=["GET"])
def example_route():
    success = False
    reason = "<Input error>"
    학번 = [30820] # int
    data = {
        "ID" : 학번,
    }
    if data['ID']: pass


    user_id = data['ID']

    deque.apply_meal(user_id)

    apply = deque.apply_meal(user_id)
    index = deque.index(user_id)

    reason = {
        "grade" : "Cannot enter",
        "input" : "Input error"
    }
    if success:
        response_data = {
            "success" : True,
            "waiting" : index
                        }
    elif filter(lambda f: f < 30000, data["ID"]):
        response_data = {
            "success" : False,
            "reason" : reason["grade"]
        }
    else:
        response_data = {
            "successs" : False,
            "reason" : reason["input"]
        }
    return response_data
if __name__ == '__main__':
    example_bp.run(debug=True)
