import quart
import pymysql

# Flask와 동일하게 작성하면 됨.
app = quart.Quart(__name__)

@app.route("/")
async def hi():
    return "Hello, world!"

app.run(port=8000)