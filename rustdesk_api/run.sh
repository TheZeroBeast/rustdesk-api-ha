#!/bin/sh
set -e

CONFIG_PATH=/data/options.json

# Ensure persistent storage for both server keys (/data) and API database (/data/api)
mkdir -p /data/api
if [ ! -L /app/data ]; then
    rm -rf /app/data
    ln -s /data/api /app/data
fi

export RUSTDESK_API_RUSTDESK_ID_SERVER=$(jq -r '.id_server' $CONFIG_PATH)
export RUSTDESK_API_RUSTDESK_RELAY_SERVER=$(jq -r '.relay_server' $CONFIG_PATH)
export RUSTDESK_API_RUSTDESK_API_SERVER=$(jq -r '.api_server' $CONFIG_PATH)
export RELAY=$(jq -r '.relay_server' $CONFIG_PATH)

ENCRYPTED=$(jq -r '.encrypted_only' $CONFIG_PATH)
if [ "$ENCRYPTED" = "true" ]; then
    export ENCRYPTED_ONLY=1
else
    export ENCRYPTED_ONLY=0
fi

MUST_LOGIN_VAL=$(jq -r '.must_login' $CONFIG_PATH)
if [ "$MUST_LOGIN_VAL" = "true" ]; then
    export MUST_LOGIN=Y
else
    export MUST_LOGIN=N
fi

JWT=$(jq -r '.jwt_key // empty' $CONFIG_PATH)
if [ -n "$JWT" ]; then
    export RUSTDESK_API_JWT_KEY="$JWT"
fi

# Point API to the auto-generated public key in /data
export RUSTDESK_API_KEY_FILE=/data/id_ed25519.pub

# Hand over process supervision to s6-overlay
exec /init
