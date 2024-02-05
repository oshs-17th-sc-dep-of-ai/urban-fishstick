import pytest
from quart import Quart
from util.seat_manager import SeatManager
from group import bp

@pytest.fixture
async def app():
    app = Quart(__name__)
    app.register_blueprint(bp)
    return app

@pytest.mark.asyncio
async def test_group_register(app):
    client = await app.test_client()
    data = {'group_members': [10001, 10002, 10003]}

    response = await client.post('/register', json=data)

    assert 'message' in (await response.get_json())
