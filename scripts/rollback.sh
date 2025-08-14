#!/bin/bash

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Count backup directories
BACKUP_DIRS=($(ls -d .backup.* 2>/dev/null || true))
BACKUP_COUNT=${#BACKUP_DIRS[@]}

if [ $BACKUP_COUNT -eq 0 ]; then
    echo -e "${RED}No backups found${NC}"
    echo "Nothing to rollback"
    exit 1
elif [ $BACKUP_COUNT -eq 1 ]; then
    # Automatic rollback from single backup
    BACKUP_DIR="${BACKUP_DIRS[0]}"
    echo -e "${GREEN}✔${NC} Rolling back from ${YELLOW}$BACKUP_DIR/${NC}"
else
    # Interactive menu for multiple backups
    echo "Multiple backups found:"
    echo ""

    # Display options
    for i in "${!BACKUP_DIRS[@]}"; do
        dir="${BACKUP_DIRS[$i]}"
        # Extract package manager name from backup directory
        pm_name="${dir#.backup.}"
        echo "  $((i+1))) $pm_name (from $dir)"
    done

    echo ""
    read -p "Select backup to restore (1-$BACKUP_COUNT): " selection

    # Validate selection
    if ! [[ "$selection" =~ ^[0-9]+$ ]] || [ "$selection" -lt 1 ] || [ "$selection" -gt $BACKUP_COUNT ]; then
        echo -e "${RED}Invalid selection${NC}"
        exit 1
    fi

    BACKUP_DIR="${BACKUP_DIRS[$((selection-1))]}"
    echo ""
    echo -e "${GREEN}✔${NC} Rolling back from ${YELLOW}$BACKUP_DIR/${NC}"
fi

# Perform rollback
if [ ! -d "$BACKUP_DIR" ]; then
    echo -e "${RED}Error: Backup directory not found: $BACKUP_DIR${NC}"
    exit 1
fi

# Remove current package manager files (but keep backup directories)
echo "  Cleaning current files..."
rm -f Dockerfile .dockerignore package-lock.json yarn.lock pnpm-lock.yaml bun.lockb .yarnrc.yml .npmrc .pnpmfile.cjs

# Restore files from backup
for file in "$BACKUP_DIR"/*; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        cp "$file" "./$filename"
        echo "  Restored: $filename"
    fi
done

echo ""
echo -e "${GREEN}✔${NC} Rollback complete!"
echo ""
echo "Note: Dependencies and lock files may need to be reinstalled"
echo "based on the restored package manager configuration."
echo ""
echo "Run the appropriate install command:"
echo "  npm install    # for npm"
echo "  yarn install   # for yarn"
echo "  pnpm install   # for pnpm"
echo "  bun install    # for bun"