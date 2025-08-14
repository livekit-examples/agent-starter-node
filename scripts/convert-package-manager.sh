#!/bin/bash

set -e

# Configuration
# GITHUB_BASE_URL="https://raw.githubusercontent.com/livekit/livekit-cli/refs/heads/main/pkg/agentfs/examples/"
# Temporary until this is merged: https://github.com/livekit/livekit-cli/pull/644
GITHUB_BASE_URL="https://raw.githubusercontent.com/livekit/livekit-cli/05790019cc1977abcc6452890811bda07f2e74b1/pkg/agentfs/examples"
PROGRAM_MAIN="dist/agent.js"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the target package manager from command line
TARGET_PM="$1"

if [ -z "$TARGET_PM" ]; then
    echo -e "${RED}Error: No package manager specified${NC}"
    echo "Usage: $0 {npm|yarn|yarn-berry|pnpm|bun}"
    exit 1
fi

# Source the detection script
source "$(dirname "$0")/detect-package-manager.sh"

# Detect current package manager
CURRENT_PM=$(detect_current_pm)

echo -e "${GREEN}✔${NC} Detected current package manager: ${YELLOW}$CURRENT_PM${NC}"

# Create backup directory
BACKUP_DIR=".backup.$CURRENT_PM"
if [ "$CURRENT_PM" = "unknown" ]; then
    BACKUP_DIR=".backup.original"
fi

echo "  Creating backup: $BACKUP_DIR/"

# Create backup
mkdir -p "$BACKUP_DIR"

# Backup existing files
[ -f "Dockerfile" ] && cp "Dockerfile" "$BACKUP_DIR/"
[ -f ".dockerignore" ] && cp ".dockerignore" "$BACKUP_DIR/"
[ -f "package.json" ] && cp "package.json" "$BACKUP_DIR/"
[ -f "package-lock.json" ] && cp "package-lock.json" "$BACKUP_DIR/"
[ -f "yarn.lock" ] && cp "yarn.lock" "$BACKUP_DIR/"
[ -f "pnpm-lock.yaml" ] && cp "pnpm-lock.yaml" "$BACKUP_DIR/"
[ -f "bun.lockb" ] && cp "bun.lockb" "$BACKUP_DIR/"
[ -f ".yarnrc.yml" ] && cp ".yarnrc.yml" "$BACKUP_DIR/"
[ -f ".npmrc" ] && cp ".npmrc" "$BACKUP_DIR/"
[ -f ".pnpmfile.cjs" ] && cp ".pnpmfile.cjs" "$BACKUP_DIR/"

echo ""
echo -e "${GREEN}✔${NC} Fetching $TARGET_PM templates from GitHub"

# Map yarn-berry to yarn-berry for the dockerfile name
DOCKERFILE_PM="$TARGET_PM"
if [ "$TARGET_PM" = "yarn-berry" ]; then
    DOCKERFILE_PM="yarn-berry"
fi

# Download Dockerfile and dockerignore
DOCKERFILE_URL="$GITHUB_BASE_URL/node.$DOCKERFILE_PM.Dockerfile"
DOCKERIGNORE_URL="$GITHUB_BASE_URL/node.$DOCKERFILE_PM.dockerignore"

curl -sL "$DOCKERFILE_URL" -o Dockerfile.tmp
if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Failed to download Dockerfile${NC}"
    echo "URL: $DOCKERFILE_URL"
    exit 1
fi

curl -sL "$DOCKERIGNORE_URL" -o .dockerignore
if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Failed to download .dockerignore${NC}"
    echo "URL: $DOCKERIGNORE_URL"
    exit 1
fi

# Replace template variable in Dockerfile
sed "s|{{\.ProgramMain}}|$PROGRAM_MAIN|g" Dockerfile.tmp > Dockerfile
rm Dockerfile.tmp

echo "  Downloaded: Dockerfile (from LiveKit template)"
echo "  Downloaded: .dockerignore (from LiveKit template)"
echo ""
echo -e "${YELLOW}⚠️  Note: Dockerfile has been reset to LiveKit template version${NC}"
echo "    Any custom modifications have been backed up"

# Update package.json packageManager field
echo ""
echo -e "${GREEN}✔${NC} Updating package.json for $TARGET_PM"

if [ -f "package.json" ]; then
    # Remove existing packageManager field and add new one based on target
    case "$TARGET_PM" in
        npm)
            # Remove packageManager field for npm (it's the default)
            node -e "
const fs = require('fs');
const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
delete pkg.packageManager;
fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2) + '\\n');
"
            echo "  Removed packageManager field (npm is default)"
            ;;
        yarn)
            node -e "
const fs = require('fs');
const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
pkg.packageManager = 'yarn@1.22.22';
fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2) + '\\n');
"
            echo "  Set packageManager: yarn@1.22.22"
            ;;
        yarn-berry)
            node -e "
const fs = require('fs');
const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
pkg.packageManager = 'yarn@4.5.3';
fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2) + '\\n');
"
            echo "  Set packageManager: yarn@4.5.3"

            # Create .yarnrc.yml for Yarn Berry
            cat > .yarnrc.yml << 'EOF'
nodeLinker: node-modules
EOF
            echo "  Created .yarnrc.yml with nodeLinker: node-modules"
            ;;
        pnpm)
            node -e "
const fs = require('fs');
const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
pkg.packageManager = 'pnpm@9.15.9';
fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2) + '\\n');
"
            echo "  Set packageManager: pnpm@9.15.9"
            ;;
        bun)
            node -e "
const fs = require('fs');
const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
pkg.packageManager = 'bun@1.1.45';
fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2) + '\\n');
"
            echo "  Set packageManager: bun@1.1.45"
            ;;
    esac
else
    echo -e "${RED}Error: package.json not found${NC}"
    exit 1
fi

echo "  Entry point: $PROGRAM_MAIN"

# Display instructions based on package manager
echo ""
echo "Next steps:"
echo "  › Install $TARGET_PM:"

case "$TARGET_PM" in
    npm)
        echo "    # npm is usually pre-installed with Node.js"
        echo ""
        echo "  › Generate lock file and install dependencies:"
        echo "    npm install"
        echo ""
        echo "  › Build the project:"
        echo "    npm run build"
        ;;
    yarn)
        echo "    npm install -g yarn@1.22.22"
        echo "    # Or use corepack: corepack enable && corepack prepare yarn@1.22.22 --activate"
        echo ""
        echo "  › Generate lock file and install dependencies:"
        echo "    yarn install"
        echo ""
        echo "  › Build the project:"
        echo "    yarn build"
        ;;
    yarn-berry)
        echo "    corepack enable"
        echo "    corepack prepare yarn@4.5.3 --activate"
        echo ""
        echo "  › Generate lock file and install dependencies:"
        echo "    yarn install"
        echo ""
        echo "  › Build the project:"
        echo "    yarn build"
        ;;
    pnpm)
        echo "    npm install -g pnpm@9.15.9"
        echo "    # Or use corepack: corepack enable && corepack prepare pnpm@9.15.9 --activate"
        echo ""
        echo "  › Generate lock file and install dependencies:"
        echo "    pnpm install"
        echo ""
        echo "  › Build the project:"
        echo "    pnpm build"
        ;;
    bun)
        echo "    curl -fsSL https://bun.sh/install | bash"
        echo "    # Or on macOS: brew install bun"
        echo ""
        echo "  › Generate lock file and install dependencies:"
        echo "    bun install"
        echo ""
        echo "  › Build the project:"
        echo "    bun run build"
        ;;
esac

echo ""
echo "  › Test locally:"
echo "    npm run dev  # or yarn/pnpm/bun run dev"
echo ""
echo "  › Build Docker image:"
echo "    docker build -t my-agent ."
echo ""
echo "To rollback: make rollback"

# List existing backups
BACKUP_COUNT=$(ls -d .backup.* 2>/dev/null | wc -l)
if [ $BACKUP_COUNT -gt 0 ]; then
    echo "Existing backups: $(ls -d .backup.* | tr '\n' ' ')"
fi