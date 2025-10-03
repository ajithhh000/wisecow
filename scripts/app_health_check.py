#!/usr/bin/env python3
import requests
import sys

URL = sys.argv[1] if len(sys.argv) > 1 else 'http://localhost:4499'

try:
    resp = requests.get(URL, timeout=5)
    if resp.status_code == 200:
        print(f"Application is UP - HTTP {resp.status_code}")
    else:
        print(f"Application is DOWN - HTTP {resp.status_code}")
except Exception as e:
    print(f"Application is DOWN! Error: {e}")
