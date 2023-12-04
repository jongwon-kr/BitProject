import os
import jwt
import uuid
import hashlib
from urllib.parse import urlencode
import requests

access_key = f"0O0byeSHERUnKUdn8WtKHTaksI9ggpx92Gpa99lG"
secret_key = f"D1AxPbP693JciipLjNPf3bcI66w3pKTU9MEwELWx"
server_url = f"https://api.upbit.com"

payload = {
    "access_key": access_key,
    "nonce": str(uuid.uuid4()),
}

jwt_token = jwt.encode(payload, secret_key)
authorization = "Bearer {}".format(jwt_token)
headers = {
    "Authorization": authorization,
}

res = requests.get(server_url + "/v1/accounts", headers=headers)

print("보유 자본")
print(res)
