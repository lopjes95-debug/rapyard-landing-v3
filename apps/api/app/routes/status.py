from utils.cors import cors_headers
import json
import datetime

def status_route():
    return {
        "statusCode": 200,
        "headers": cors_headers(),
        "body": json.dumps({
            "ok": True,
            "service": "rapyard-api",
            "time": datetime.datetime.utcnow().isoformat()
        })
    }
