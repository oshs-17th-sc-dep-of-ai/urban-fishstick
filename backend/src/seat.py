from quart import Blueprint, request, jsonify

bp = Blueprint('seat', __name__)

@bp.route('/enter', methods=['POST'])
async def seat_enter():

@bp.route('/exit', methods=['POST'])
async def seat_exit():

@bp.route('/remain', methods=['GET'])
async def seat_remain():

@bp.route('/enter/prior', methods=['POST'])
async def seat_enter_prior():
