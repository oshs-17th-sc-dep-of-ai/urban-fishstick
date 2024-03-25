from quart import Quart

from seat import seat_bp
from group import group_bp
from prior import prior_bp
from feedback import feedback_bp

from util.json_util import read_json

__server_config = read_json("../config/server.json")

app = Quart(__name__)

app.register_blueprint(seat_bp, url_prefix="/seat")
app.register_blueprint(group_bp, url_prefix="/group")
app.register_blueprint(prior_bp, url_prefix="/prior")
app.register_blueprint(feedback_bp, url_prefix="/feedback")

# * 개발 완료 시 config/server.json에서 debug=False로 변경 필요 *
app.run(port=__server_config["port"], debug=__server_config["debug"], use_reloader=False)
