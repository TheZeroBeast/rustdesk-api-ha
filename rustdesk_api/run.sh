#!/bin/sh
set -e

OPTIONS_FILE="/data/options.json"

mkdir -p /data/rustdesk
rm -rf /app/data
ln -s /data/rustdesk /app/data

export RUSTDESK_API_RUSTDESK_ID_SERVER=$(jq -r '.id_server' "$OPTIONS_FILE")
export RUSTDESK_API_RUSTDESK_RELAY_SERVER=$(jq -r '.relay_server' "$OPTIONS_FILE")
export RUSTDESK_API_RUSTDESK_API_SERVER=$(jq -r '.api_server' "$OPTIONS_FILE")
export RUSTDESK_API_RUSTDESK_KEY=$(jq -r '.public_key' "$OPTIONS_FILE")
export RUSTDESK_API_LANG=$(jq -r '.lang' "$OPTIONS_FILE")

echo "Starting RustDesk API Server..."
exec /app/apimain
