from app.utils.cors import cors_headers

def time_route():
    return {
        "statusCode": 200,
        "headers": cors_headers(),
        "body": json.dumps({
            "now": datetime.datetime.utcnow().isoformat()
        })
    }
