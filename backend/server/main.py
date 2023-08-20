from fastapi import FastAPI

app = FastAPI()

request_count = 0

@app.get("/request/{client_id}")
async def count(client_id):
    global request_count
    request_count += 1

    return {"client_id": client_id, "request_count": request_count}
