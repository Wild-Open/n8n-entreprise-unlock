#!/bin/bash

# n8n Enterprise Unlock Main Script
# This script unlocks all enterprise features and removes invitation restrictions

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔓 n8n Enterprise Unlock Script${NC}"
echo -e "${BLUE}=================================${NC}"
echo ""
echo -e "${YELLOW}Environment variables:${NC}"
echo -e "  N8N_HIDE_PRODUCTION_WARNING=${N8N_HIDE_PRODUCTION_WARNING:-false} (hide production warning)"
echo ""

# Default containers - you can customize this list
DEFAULT_CONTAINERS=("n8n-n8n-1" "n8n-mbataa-n8n-1" "n8n-mb2athena-n8n-1" "n8n-mbatad-n8n-1")

# Function to display usage
usage() {
    echo -e "${YELLOW}Usage: $0 [container1 container2 ...]${NC}"
    echo ""
    echo "If no containers are specified, will unlock: ${DEFAULT_CONTAINERS[*]}"
    echo ""
    echo "Examples:"
    echo "  $0                                    # Unlock default containers"
    echo "  $0 n8n-n8n-1                        # Unlock single container"
    echo "  $0 container1 container2 container3 # Unlock multiple containers"
    exit 1
}

# Parse arguments
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    usage
fi

CONTAINERS=("$@")
if [ ${#CONTAINERS[@]} -eq 0 ]; then
    CONTAINERS=("${DEFAULT_CONTAINERS[@]}")
fi

echo -e "${GREEN}🎯 Target containers: ${CONTAINERS[*]}${NC}"
echo ""

# Function to check if container exists and is running
check_container() {
    local container=$1
    if ! docker ps --format "table {{.Names}}" | grep -q "^$container$"; then
        echo -e "${RED}❌ Container '$container' is not running or doesn't exist${NC}"
        return 1
    fi
    echo -e "${GREEN}✅ Container '$container' is running${NC}"
    return 0
}

# Function to unlock a single container
unlock_container() {
    local container=$1
    echo -e "${YELLOW}🔧 Unlocking container: $container${NC}"
    
    # Run permissions unlock
    echo -e "  ${BLUE}📝 Applying permissions unlock...${NC}"
    ./permissions-unlock.sh "$container"
    
    # Run license bypass
    echo -e "  ${BLUE}💳 Applying license bypass...${NC}"
    ./license-bypass.sh "$container"
    
    echo -e "${GREEN}✅ Container '$container' unlocked successfully!${NC}"
}

# Main execution
echo -e "${BLUE}🔍 Checking containers...${NC}"
for container in "${CONTAINERS[@]}"; do
    check_container "$container"
done

echo ""
echo -e "${BLUE}🚀 Starting unlock process...${NC}"
echo ""

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Make scripts executable
chmod +x permissions-unlock.sh license-bypass.sh

# Unlock each container
for container in "${CONTAINERS[@]}"; do
    if docker ps --format "table {{.Names}}" | grep -q "^$container$"; then
        unlock_container "$container"
        echo ""
    fi
done

echo -e "${GREEN}🎉 All containers unlocked successfully!${NC}"
echo ""
echo -e "${YELLOW}📋 Next steps:${NC}"
echo "1. Restart containers to apply changes:"
for container in "${CONTAINERS[@]}"; do
    if docker ps --format "table {{.Names}}" | grep -q "^$container$"; then
        echo "   docker restart $container"
    fi
done
echo ""
echo "2. Wait for containers to start up (30 seconds recommended)"
echo "3. Verify enterprise features are available in n8n web interface"
echo ""
echo -e "${BLUE}🎯 What you can now do:${NC}"
echo -e "  • ${GREEN}✓${NC} Invite users as Admin, Member, or Chat User (no more restrictions)"
echo -e "  • ${GREEN}✓${NC} Access all enterprise features (no 'Available on Enterprise plan' messages)"
echo -e "  • ${GREEN}✓${NC} Create unlimited admin users"
echo -e "  • ${GREEN}✓${NC} Use advanced permissions, SSO, LDAP, and other enterprise features"
echo ""
echo -e "${RED}⚠️  Warning: This is for development/testing only. Not for production use!${NC}"