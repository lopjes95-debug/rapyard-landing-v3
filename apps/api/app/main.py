from app.routes.status import status_route
from app.routes.time import time_route
from app.routes.users import users_route
from app.utils.cors import cors_headers

def handler(event, context):
    path = event.get("rawPath", "/")
    method = event.get("requestContext", {}).get("http", {}).get("method", "GET")

    if path == "/status":
        return status_route()

    if path == "/time":
        return time_route()

    if path == "/users":
        if method == "GET":
            return users_route()

    return {
        "statusCode": 404,
        "headers": cors_headers(),
        "body": '{"error": "Not found"}'
    }
