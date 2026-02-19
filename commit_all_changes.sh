#!/bin/bash

# Add all changes (including untracked files)
git add .

# Prompt for commit message, default to timestamp if empty
echo "Enter commit message (Press Enter for default):"
read -r msg

if [ -z "$msg" ]; then
    msg="Auto-commit: $(date '+%Y-%m-%d %H:%M:%S')"
fi

# Commit changes
git commit -m "$msg"

# Push changes (optional, uncomment if needed)
# git push origin main

echo "Changes committed with message: '$msg'"
