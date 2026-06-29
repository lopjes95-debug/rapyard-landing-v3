$ErrorActionPreference = "Stop"

# 1. Create project root and enter it
$root = "C:\dev\rapyard"
New-Item -ItemType Directory -Path $root -Force | Out-Null
Set-Location $root

# 2. Python venv (optional but recommended)
python -m venv .venv
& "$root\.venv\Scripts\Activate.ps1"

# 3. requirements.txt
@"
supabase
python-dotenv
"@ | Set-Content -Path "$root\requirements.txt"

pip install -r requirements.txt

# 4. Install Serverless Framework globally
npm install -g serverless

# 5. serverless.yml
@"
service: rapyard-api

provider:
  name: aws
  runtime: python3.11
  region: us-east-1
  environment:
    SUPABASE_URL: https://YOUR-PROJECT.supabase.co
    SUPABASE_SERVICE_ROLE_KEY: ${ssm:/rapyard/supabase/service_role}

functions:
  api:
    handler: apps/api/app/main.handler
    events:
      - httpApi:
          path: /{proxy+}
          method: ANY

package:
  patterns:
    - "apps/api/**"
    - "!**/__pycache__/**"
"@ | Set-Content -Path "$root\serverless.yml"

# 6. Folder structure
New-Item -ItemType Directory -Path "apps\api\app\routes" -Force | Out-Null
New-Item -ItemType Directory -Path "apps\api\app\utils" -Force | Out-Null
New-Item -ItemType Directory -Path "apps\api\app\services" -Force | Out-Null
New-Item -ItemType Directory -Path "apps\api\tests" -Force | Out-Null
New-Item -ItemType Directory -Path "apps\ui\src" -Force | Out-Null
New-Item -ItemType Directory -Path "apps\ui\public" -Force | Out-Null
New-Item -ItemType Directory -Path "infra\iam" -Force | Out-Null
New-Item -ItemType Directory -Path "infra\policies" -Force | Out-Null
New-Item -ItemType Directory -Path "infra\scripts" -Force | Out-Null

# 7. __init__.py files
"" | Set-Content "apps\api\app\__init__.py"
"" | Set-Content "apps\api\app\routes\__init__.py"
"" | Set-Content "apps\api\app\utils\__init__.py"
"" | Set-Content "apps\api\app\services\__init__.py"
"" | Set-Content "apps\api\tests\__init__.py"
"" | Set-Content "apps\api\__init__.py"

# 8. main.py
@"
from routes.status import status_route
from routes.time import time_route
from routes.users import users_route
from utils.cors import cors_headers

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
"@ | Set-Content "apps\api\app\main.py"

# 9. cors.py
@"
def cors_headers():
    return {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Credentials": "true",
        "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
        "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
    }
"@ | Set-Content "apps\api\app\utils\cors.py"

# 10. supabase_client.py
@"
import os
from supabase import create_client, Client

_supabase: Client | None = None

def supabase() -> Client:
    global _supabase
    if _supabase is None:
        url = os.environ["SUPABASE_URL"]
        key = os.environ["SUPABASE_SERVICE_ROLE_KEY"]
        _supabase = create_client(url, key)
    return _supabase
"@ | Set-Content "apps\api\app\services\supabase_client.py"

# 11. status.py
@"
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
"@ | Set-Content "apps\api\app\routes\status.py"

# 12. time.py
@"
from utils.cors import cors_headers
import json
import datetime

def time_route():
    return {
        "statusCode": 200,
        "headers": cors_headers(),
        "body": json.dumps({
            "now": datetime.datetime.utcnow().isoformat()
        })
    }
"@ | Set-Content "apps\api\app\routes\time.py"

# 13. users.py
@"
from utils.cors import cors_headers
from services.supabase_client import supabase
import json

def users_route():
    data = supabase().table("users").select("*").limit(10).execute()

    return {
        "statusCode": 200,
        "headers": cors_headers(),
        "body": json.dumps({
            "users": data.data
        })
    }
"@ | Set-Content "apps\api\app\routes\users.py"

# 14. tests
@"
from app.routes.status import status_route

def test_status():
    res = status_route()
    assert res["statusCode"] == 200
"@ | Set-Content "apps\api\tests\test_status.py"

@"
from app.routes.time import time_route

def test_time():
    res = time_route()
    assert res["statusCode"] == 200
"@ | Set-Content "apps\api\tests\test_time.py"

# 15. API README
@"
# RapYard API (AWS Lambda + Supabase)

Backend for RapYard, running on AWS Lambda via Serverless Framework.

Routes:
- GET /status
- GET /time
- GET /users

Supabase:
- Uses service role key stored in AWS SSM at /rapyard/supabase/service_role
"@ | Set-Content "apps\api\README.md"

# 16. Minimal UI placeholder
@"
{
  `"name`": `"@rapyard/ui`",
  `"private`": true,
  `"scripts`": {
    `"dev`": `"echo \"UI dev server placeholder\"`",
    `"build`": `"echo \"UI build placeholder\"`"
  },
  `"dependencies`": {},
  `"devDependencies`": {}
}
"@ | Set-Content "apps\ui\package.json"

@"
export default function App() {
  return <div>RapYard UI placeholder</div>
}
"@ | Set-Content "apps\ui\src\index.tsx"

# 17. infra README
@"
# RapYard Infra

- IAM roles
- Policies
- Deployment scripts
"@ | Set-Content "infra\README.md"

Write-Host "Bootstrap complete.`n`nNext steps:`n 1) Put Supabase service role key in AWS SSM:`n    aws ssm put-parameter --name /rapyard/supabase/service_role --value \"YOUR_SERVICE_ROLE_KEY\" --type SecureString`n 2) Install serverless-offline plugin and run locally:`n    serverless plugin install -n serverless-offline`n    serverless offline`n 3) Deploy:`n    serverless deploy"
