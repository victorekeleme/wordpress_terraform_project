#!/usr/bin/env python3

import boto3
import json
import sys
import subprocess
import os

client = boto3.client('secretsmanager', region_name='us-east-2')

response = client.get_secret_value(
    SecretId='credentials'
)

credentials = json.loads(response['SecretString'])

for key,value in credentials.items():
    print(key,value)
    cred=f"{key+'='+value}"
    try:
        if sys.platform.startswith('linux'):
            if key == 'EFS_DNS_NAME':
                os.system(f"echo {value} >> ~/efs")
            else:
                os.system(f"echo {cred} >> ~/wordpress.env")
    except Exception as e:
        print(e)
