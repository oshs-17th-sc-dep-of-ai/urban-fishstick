from quart import Quart
import pymysql

from seat import bp as seat_bp
from group import bp as group_bp
from feedback import bp as feedback_bp

from ..util.json_util import read_json, write_json
from ..util.seat_manager import SeatManager

__db_config = read_json("../config/database.json")

app = Quart(__name__)
seat_manager = SeatManager()
db_conn = pymysql.connect(
    host=__db_config["host"],
    user=__db_config["user"],
    password=__db_config["password"],
    database="ohsung_lunch"
)

app.register_blueprint(feedback_bp)
app.register_blueprint(group_bp)
app.register_blueprint(seat_bp)

app.run(port=8720)
