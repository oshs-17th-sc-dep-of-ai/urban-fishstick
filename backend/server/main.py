from flask import Blueprint, jsonify, Flask

example_bp = Flask(__name__)
profile = Blueprint("profile", __name__)
example_bp.register_blueprint(profile, url_prefix='/profile')

@example_bp.route('/send', methods=['GET'])
def example_route():
    who = 'JSONdata'
    apply = 'jsondata'
    result = {
        who : apply
    }
    return jsonify(result=result)
if __name__ == '__main__':
    example_bp.run()