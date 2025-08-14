# Package Manager Conversion Tool for Node.js LiveKit Agent
# This Makefile helps convert between different Node.js package managers

.PHONY: help convert-to-npm convert-to-yarn convert-to-yarn-berry convert-to-pnpm convert-to-bun rollback list-backups clean-backups

# Default target shows help
help:
	@echo "Package Manager Conversion Tool - Node.js"
	@echo "=========================================="
	@echo ""
	@echo "⚠️  WARNING: Converting will reset Dockerfiles to LiveKit templates"
	@echo "    Any custom Dockerfile modifications will be lost!"
	@echo ""
	@echo "Available conversion targets:"
	@echo "  make convert-to-npm        - Convert to npm"
	@echo "  make convert-to-yarn       - Convert to Yarn Classic (v1)"
	@echo "  make convert-to-yarn-berry - Convert to Yarn Berry (v3+)"
	@echo "  make convert-to-pnpm       - Convert to pnpm"
	@echo "  make convert-to-bun        - Convert to Bun"
	@echo ""
	@echo "Backup management:"
	@echo "  make rollback           - Restore from backup (interactive if multiple)"
	@echo "  make list-backups       - Show available backups"
	@echo "  make clean-backups      - Remove all backup directories"
	@echo ""
	@echo "Notes:"
	@echo "  • Backups are saved as .backup.{package-manager}"
	@echo "  • Multiple conversions create multiple backups"
	@echo "  • Rollback is interactive when multiple backups exist"
	@echo "  • Lock files are NOT generated automatically - see instructions after conversion"

convert-to-npm:
	@bash scripts/convert-package-manager.sh npm

convert-to-yarn:
	@bash scripts/convert-package-manager.sh yarn

convert-to-yarn-berry:
	@bash scripts/convert-package-manager.sh yarn-berry

convert-to-pnpm:
	@bash scripts/convert-package-manager.sh pnpm

convert-to-bun:
	@bash scripts/convert-package-manager.sh bun

rollback:
	@bash scripts/rollback.sh

list-backups:
	@echo "Available backups:"
	@for dir in .backup.*; do \
		if [ -d "$$dir" ]; then \
			echo "  $$dir"; \
		fi; \
	done 2>/dev/null || echo "  No backups found"

clean-backups:
	@echo "Removing all backup directories..."
	@rm -rf .backup.* 2>/dev/null || true
	@echo "✔ All backups removed"