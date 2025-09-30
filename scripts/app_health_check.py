#!/usr/bin/env python3
# app_health_check.py
# usage: python3 app_health_check.py http://localhost:4499/ --timeout 5
import argparse
import requests
import sys
from datetime import datetime

parser = argparse.ArgumentParser()
parser.add_argument('url', help='URL to check')
parser.add_argument('--timeout', type=int, default=5)
parser.add_argument('--expected', type=int, default=200, help='Expected HTTP status code')
args = parser.parse_args()

try:
    r = requests.get(args.url, timeout=args.timeout)
    status = r.status_code
    ok = (status == args.expected)
    now = datetime.utcnow().isoformat() + 'Z'
    if ok:
        print(f"{now} INFO: {args.url} returned {status} (up)")
        sys.exit(0)
    else:
        print(f"{now} ERROR: {args.url} returned {status} (expected {args.expected})")
        sys.exit(2)
except Exception as e:
    now = datetime.utcnow().isoformat() + 'Z'
    print(f"{now} ERROR: {args.url} not reachable: {e}")
    sys.exit(1)
