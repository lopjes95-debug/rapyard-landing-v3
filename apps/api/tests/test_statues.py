def test_status():
    from app.routes.status import status_route
    res = status_route()
    assert res["statusCode"] == 200
