from quart import Blueprint, request, jsonify

bp = Blueprint('feedback', __name__)

@bp.route('/add', methods=['POST'])
async def feedback_add():

@bp.route('/get/<filename>', methods=['GET'])
async def feedback_get(filename):
