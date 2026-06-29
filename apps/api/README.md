# RapYard API (AWS Lambda + Supabase)

Backend for RapYard, running on AWS Lambda via Serverless Framework.

Routes:
- GET /status
- GET /time
- GET /users

Supabase:
- Uses service role key stored in AWS SSM at /rapyard/supabase/service_role
