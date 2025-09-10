#!/bin/bash

# Script to update camille from upstream caelestia-dots/shell
# This script will:
# 1. Fetch latest changes from upstream
# 2. Create a backup branch with current changes
# 3. Reset main to upstream
# 4. Restore personal configurations
# 5. Push changes

set -e

echo "🔄 Updating camille from upstream caelestia-dots/shell..."

# Check if we're on main branch
current_branch=$(git branch --show-current)
if [ "$current_branch" != "main" ]; then
    echo "❌ Please switch to main branch first"
    exit 1
fi

# Fetch latest from upstream
echo "📥 Fetching latest changes from upstream..."
git fetch upstream

# Create backup branch with current state
backup_branch="backup-$(date +%Y%m%d-%H%M%S)"
echo "💾 Creating backup branch: $backup_branch"
git checkout -b "$backup_branch"
git push origin "$backup_branch"

# Switch back to main and reset to upstream
echo "🔄 Resetting main to upstream..."
git checkout main
git reset --hard upstream/main

# Restore personal configurations
echo "🔧 Restoring personal configurations..."
git checkout "$backup_branch" -- config/
git checkout "$backup_branch" -- services/
git checkout "$backup_branch" -- modules/
git checkout "$backup_branch" -- assets/globe.gif assets/kurukuru.gif

# Check for conflicts
if [ -n "$(git status --porcelain)" ]; then
    echo "📝 Personal configurations restored. Please review and commit changes:"
    git status
    echo ""
    echo "After reviewing, run:"
    echo "  git add ."
    echo "  git commit -m 'Update from upstream with personal configs'"
    echo "  git push origin main"
else
    echo "✅ No personal configurations to restore"
fi

echo "🎉 Update process completed!"
echo "📋 Next steps:"
echo "  1. Review any changes: git status"
echo "  2. Test your configuration"
echo "  3. Commit and push if needed: git add . && git commit -m 'Update from upstream' && git push origin main"
echo "  4. Clean up backup branch if everything works: git branch -D $backup_branch"
