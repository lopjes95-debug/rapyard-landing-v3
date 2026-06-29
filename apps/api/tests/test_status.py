from app.routes.status import status_route

def test_status():
    res = status_route()
    assert res["statusCode"] == 200
