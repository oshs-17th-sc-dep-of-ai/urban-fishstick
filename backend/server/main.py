from flask import Blueprint, jsonify, Flask

example_bp = Flask(__name__)
profile = Blueprint("profile", __name__)
example_bp.register_blueprint(profile, url_prefix='/profile')
count = 0
@example_bp.route('/send', methods=["POST"])
def example_route():
    global count
    data = {
        "ID" : 20820,
        "check" : True
    }

    user_id = data['ID']
    check_value = data['check']
    count += 1

    response_data = {
        'ID': user_id,
        'check': check_value,
        'result': count
    }
    return jsonify(response_data)
if __name__ == '__main__':
    example_bp.run()
