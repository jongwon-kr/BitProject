import os
import jwt
import uuid
import hashlib
from urllib.parse import urlencode
import requests

access_key = f"access_key"
secret_key = f"secret_key"
server_url = f"https://api.upbit.com"

payload = {
    "access_key": access_key,
    "nonce": str(uuid.uuid4()),
}

jwt_token = jwt.encode(payload, secret_key)
authorize_token = "Bearer {}".format(jwt_token)
# print(authorize_token)
headers = {"Authorization": authorize_token}

res = requests.get(server_url + "/v1/accounts", headers=headers)

currency_data = dict(res.json()[0])

print("보유 자본")
print(f"{currency_data['currency']}: {currency_data['balance']}")
