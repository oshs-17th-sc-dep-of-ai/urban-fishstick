from quart import Blueprint, request, jsonify

bp = Blueprint('group', __name__)

@bp.route('/register', methods=['POST'])
async def group_register():

@bp.route('/index', methods=['POST'])
async def group_index():