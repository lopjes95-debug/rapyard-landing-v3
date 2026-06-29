from app.utils.cors import cors_headers

def test_time():
    res = time_route()
    assert res["statusCode"] == 200
