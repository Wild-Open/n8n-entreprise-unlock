#!/bin/bash

# n8n Enterprise Permissions Unlock Script
# This script adds user:create and user:changeRole permissions to member and chat user roles

set -e

CONTAINER_NAME=${1:-"n8n-n8n-1"}

echo "🔓 Unlocking n8n permissions for container: $CONTAINER_NAME"

# Get the path to the global scopes file
SCOPES_FILE="/usr/local/lib/node_modules/n8n/node_modules/.pnpm/@n8n+permissions@file+packages+@n8n+permissions/node_modules/@n8n/permissions/dist/roles/scopes/global-scopes.ee.js"

echo "📝 Adding user:create permission to GLOBAL_MEMBER_SCOPES..."
docker exec -u root "$CONTAINER_NAME" sed -i '/exports.GLOBAL_MEMBER_SCOPES = \[/a\    '\''user:create'\'',' "$SCOPES_FILE"

echo "📝 Adding user:changeRole permission to GLOBAL_MEMBER_SCOPES..."
docker exec -u root "$CONTAINER_NAME" sed -i '/exports.GLOBAL_MEMBER_SCOPES = \[/a\    '\''user:changeRole'\'',' "$SCOPES_FILE"

echo "📝 Adding user:create permission to GLOBAL_CHAT_USER_SCOPES..."
docker exec -u root "$CONTAINER_NAME" sed -i '/exports.GLOBAL_CHAT_USER_SCOPES = \[/a\    '\''user:create'\'',' "$SCOPES_FILE"

echo "📝 Adding user:changeRole permission to GLOBAL_CHAT_USER_SCOPES..."
docker exec -u root "$CONTAINER_NAME" sed -i '/exports.GLOBAL_CHAT_USER_SCOPES = \[/a\    '\''user:changeRole'\'',' "$SCOPES_FILE"

echo "✅ Permissions unlocked successfully!"

# Verify the changes
echo "🔍 Verifying GLOBAL_MEMBER_SCOPES changes..."
docker exec "$CONTAINER_NAME" grep -A 3 "GLOBAL_MEMBER_SCOPES = \[" "$SCOPES_FILE"

echo "🔍 Verifying GLOBAL_CHAT_USER_SCOPES changes..."
docker exec "$CONTAINER_NAME" grep -A 3 "GLOBAL_CHAT_USER_SCOPES = \[" "$SCOPES_FILE"