from quart import Quart
import pymysql

from seat import bp as seat_bp
from group import bp as group_bp
from prior import bp as prior_bp
from feedback import bp as feedback_bp

from util.json_util import read_json
from util.seat_manager import SeatManager

__db_config = read_json("../config/database.json")

app = Quart(__name__)
seat_manager = SeatManager()
db_conn = pymysql.connect(
    host=__db_config["host"],
    user=__db_config["user"],
    password=__db_config["password"],
    database="ohsung_lunch"
)

app.register_blueprint(seat_bp, url_prefix="/seat")
app.register_blueprint(group_bp, url_prefix="/group")
app.register_blueprint(prior_bp, url_prefix="/prior")
app.register_blueprint(feedback_bp, url_prefix="/feedback")

app.run(port=8720, debug=True)  # TODO: 개발 완료 시 debug=True 제거
