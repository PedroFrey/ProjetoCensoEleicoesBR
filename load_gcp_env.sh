#!/usr/bin/env bash

echo "$GCP_SERVICE_ACCOUNT" | python3 -c "
import json,sys
creds=json.load(sys.stdin)
for k,v in creds.items():
    if isinstance(v,str):
        print(f'export GCP_{k.upper()}=\"{v}\"')
"