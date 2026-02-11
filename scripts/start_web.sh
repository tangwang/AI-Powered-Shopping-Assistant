#!/usr/bin/env bash
set -euo pipefail

echo "[web] starting streamlit on port 6008..."
streamlit run app.py --server.port 6008
