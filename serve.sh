#!/usr/bin/env bash
# Serve the app locally. Bind 0.0.0.0 per repo convention; open via 127.0.0.1.
cd "$(dirname "$0")"
exec python3 -m http.server 0.0.0.0 "${PORT:-8000}"
