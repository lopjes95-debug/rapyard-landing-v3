from app.utils.cors import cors_headers
from app.services.supabase_client import supabase

def users_route():
    data = supabase().table("users").select("*").limit(10).execute()

    return {
        "statusCode": 200,
        "headers": cors_headers(),
        "body": json.dumps({
            "users": data.data
        })
    }
