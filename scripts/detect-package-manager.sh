#!/bin/bash

# Detect the current Node.js package manager based on existing files

detect_current_pm() {
    # Check for various package manager lock files in order of specificity

    # Bun (check for bun.lockb)
    if [ -f "bun.lockb" ]; then
        echo "bun"
        return
    fi

    # pnpm (check for pnpm-lock.yaml)
    if [ -f "pnpm-lock.yaml" ]; then
        echo "pnpm"
        return
    fi

    # Yarn Berry (check for .yarnrc.yml with nodeLinker)
    if [ -f ".yarnrc.yml" ]; then
        echo "yarn-berry"
        return
    fi

    # Yarn Classic (check for yarn.lock)
    if [ -f "yarn.lock" ]; then
        echo "yarn"
        return
    fi

    # npm (check for package-lock.json)
    if [ -f "package-lock.json" ]; then
        echo "npm"
        return
    fi

    # Check packageManager field in package.json
    if [ -f "package.json" ]; then
        PM_FIELD=$(node -p "require('./package.json').packageManager || ''" 2>/dev/null || echo "")
        if [ ! -z "$PM_FIELD" ]; then
            if [[ "$PM_FIELD" == *"pnpm"* ]]; then
                echo "pnpm"
                return
            elif [[ "$PM_FIELD" == *"yarn"* ]]; then
                # Check yarn version to determine classic vs berry
                if [[ "$PM_FIELD" == *"yarn@3"* ]] || [[ "$PM_FIELD" == *"yarn@4"* ]]; then
                    echo "yarn-berry"
                else
                    echo "yarn"
                fi
                return
            elif [[ "$PM_FIELD" == *"bun"* ]]; then
                echo "bun"
                return
            elif [[ "$PM_FIELD" == *"npm"* ]]; then
                echo "npm"
                return
            fi
        fi
    fi

    # Default to npm if package.json exists but no lock file
    if [ -f "package.json" ]; then
        echo "npm"
        return
    fi

    echo "unknown"
}

# If script is executed directly, print the detected package manager
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    detect_current_pm
fi