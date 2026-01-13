# n8n Enterprise Unlock

A collection of scripts to unlock all n8n enterprise features for development and testing purposes.

## ⚠️ Disclaimer

**This is intended for development and testing only. Do not use in production environments.**
These scripts modify n8n core files to bypass license checks and permission restrictions.

## 🚀 What This Unlocks

- ✅ **User Invitation Restrictions**: Members and Chat Users can invite users as Admin, Member, or Chat User
- ✅ **Enterprise Features**: Access all enterprise features without "Available on Enterprise plan" messages
- ✅ **Unlimited Admin Users**: Create unlimited admin users (no "Upgrade to unlock" messages)
- ✅ **Advanced Permissions**: Use advanced permission features
- ✅ **All Enterprise Modules**: SSO, LDAP, external secrets, and more

## 📋 Prerequisites

- Docker must be installed and running
- n8n containers must be running
- Sufficient permissions to execute Docker commands

## 🛠️ Usage

### Quick Start (Default Containers)

The script automatically targets the default n8n container:
- `n8n-n8n-1`

```bash
# Make scripts executable
chmod +x unlock-n8n-enterprise.sh

# Run unlock on default container
./unlock-n8n-enterprise.sh

# Restart container to apply changes
docker restart n8n-n8n-1
```

### Custom Container Names

```bash
# Unlock specific container
./unlock-n8n-enterprise.sh my-n8n-container

# Unlock multiple specific containers
./unlock-n8n-enterprise.sh container1 container2 container3

# Show help
./unlock-n8n-enterprise.sh --help
```

### Individual Scripts

You can also run individual scripts:

```bash
# Only unlock permissions (user invitation restrictions)
./permissions-unlock.sh container-name

# Only bypass license checks (enterprise features)
./license-bypass.sh container-name
```

## 🔧 What the Scripts Do

### `permissions-unlock.sh`

Adds these permissions to user roles:
- `user:create` - Allows inviting new users
- `user:changeRole` - Allows changing user roles

**Modified roles:**
- `GLOBAL_MEMBER_SCOPES`
- `GLOBAL_CHAT_USER_SCOPES`

### `license-bypass.sh`

Modifies these methods in `/usr/local/lib/node_modules/n8n/dist/license.js`:
- `isLicensed()` - Always returns `true`
- `isWithinUsersLimit()` - Always returns `true`
- `if (!this.isLicensed())` - Conditionally modified based on `N8N_HIDE_PRODUCTION_WARNING` env var

**Environment variable:**
- `N8N_HIDE_PRODUCTION_WARNING` (default: `false`) - Set to `true` to hide the "This n8n instance is not licensed for production purposes" warning

## 🔄 Reverting Changes

To restore original functionality, you'll need to restart containers with fresh images:

```bash
# Remove modified container
docker rm -f n8n-n8n-1

# Pull fresh images and restart (adjust your docker-compose or commands)
docker-compose up -d
```

## 🧪 Verification

After applying changes and restarting containers:

1. **Check User Invitation**: Go to Settings → Users → Invite User
   - Admin and Chat User roles should be selectable (not greyed out)

2. **Check Enterprise Features**: Look for any "Available on Enterprise plan" messages
   - All enterprise features should be accessible

3. **Check User Limits**: Try creating multiple admin users
   - No upgrade messages should appear

## 📁 File Structure

```
n8n-enterprise-unlock/
├── unlock-n8n-enterprise.sh    # Main unlock script
├── permissions-unlock.sh       # Permission modifications
├── license-bypass.sh           # License bypass
└── README.md                   # This file
```

## 🐛 Troubleshooting

### Container Not Found
```
❌ Container 'n8n-n8n-1' is not running or doesn't exist
```
- Check if the container name is correct: `docker ps`
- Use the correct container name as argument

### Permission Denied
```
permission denied while trying to connect to the Docker daemon socket
```
- Add your user to docker group: `sudo usermod -aG docker $USER`
- Or run with sudo: `sudo ./unlock-n8n-enterprise.sh`

### Changes Not Applied
- Make sure containers are restarted after running scripts
- Wait at least 30 seconds for containers to fully start
- Clear browser cache if UI still shows restrictions

## 🎯 Development Benefits

This unlock enables full development testing of:
- Multi-user workflows with different permission levels
- Enterprise integrations (SSO, LDAP, external secrets)
- Advanced permission scenarios
- User management workflows
- All n8n features without limitations

## ⚡ Quick One-Liner

For experienced users:

```bash
curl -sSL https://raw.githubusercontent.com/Wild-Open/n8n-entreprise-unlock/main/unlock-n8n-enterprise.sh | bash -s -- container-name
```

## 📞 Support

If you encounter issues:
1. Check container names with `docker ps`
2. Verify Docker is running and accessible
3. Ensure scripts have execute permissions
4. Restart containers after modifications

---

**Remember**: This is for development/testing only. Always respect n8n's licensing terms and consider purchasing an enterprise license for production use.