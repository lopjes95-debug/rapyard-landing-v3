def cors_headers():
    return {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Credentials": "true",
        "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
        "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
    }

def handler(event, context):
    path = event.get("rawPath", "/")

    if path == "/status":
        return {
            "statusCode": 200,
            "headers": cors_headers(),
            "body": '{"ok": true, "service": "rapyard-api"}'
        }

    if path == "/time":
        import datetime
        return {
            "statusCode": 200,
            "headers": cors_headers(),
            "body": '{"now": "%s"}' % datetime.datetime.utcnow().isoformat()
        }

    return {
        "statusCode": 404,
        "headers": cors_headers(),
        "body": '{"error": "Not found"}'
    }
