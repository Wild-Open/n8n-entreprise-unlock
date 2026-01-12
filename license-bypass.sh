#!/bin/bash

# n8n Enterprise License Bypass Script
# This script disables license checks to unlock all enterprise features

set -e

CONTAINER_NAME=${1:-"n8n-n8n-1"}

echo "🔓 Bypassing n8n license checks for container: $CONTAINER_NAME"

# Get the path to the license file
LICENSE_FILE="/usr/local/lib/node_modules/n8n/dist/license.js"

echo "📝 Modifying isLicensed() method to always return true..."
docker exec -u root "$CONTAINER_NAME" sed -i 's/return this\.manager?.hasFeatureEnabled(feature) ?? false;/return true;/' "$LICENSE_FILE"

echo "📝 Modifying isWithinUsersLimit() method to always return true..."
docker exec -u root "$CONTAINER_NAME" sed -i 's/return this.getUsersLimit() === constants_1.UNLIMITED_LICENSE_QUOTA;/return true;/' "$LICENSE_FILE"

echo "📝 Removing production license warning..."
docker exec -u root "$CONTAINER_NAME" sed -i 's/if (!this.isLicensed())/if (false)/' "$LICENSE_FILE"

echo "✅ License bypass completed successfully!"

# Verify the changes
echo "🔍 Verifying isLicensed() modification..."
docker exec "$CONTAINER_NAME" grep -A 2 "isLicensed(feature)" "$LICENSE_FILE"

echo "🔍 Verifying isWithinUsersLimit() modification..."
docker exec "$CONTAINER_NAME" grep -A 2 "isWithinUsersLimit()" "$LICENSE_FILE"

echo "🔍 Verifying production warning removal..."
docker exec "$CONTAINER_NAME" grep -A 2 "if (!this.isLicensed())" "$LICENSE_FILE"