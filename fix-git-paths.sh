#!/bin/bash

echo "🔍 Searching for invalid Git paths with accidental spaces..."

# Find tracked files with suspicious space-containing paths (e.g., 'public /')
INVALID_PATHS=$(git ls-files | grep -E " /")

if [ -z "$INVALID_PATHS" ]; then
  echo "✅ No invalid paths found!"
  exit 0
fi

echo "🚫 Found the following problematic tracked files:"
echo "$INVALID_PATHS"

# Remove each invalid path from index
echo ""
echo "🧹 Removing invalid paths from Git index..."
while IFS= read -r path; do
  echo " - Removing: $path"
  git rm --cached "$path"
done <<< "$INVALID_PATHS"

echo ""
echo "✅ Invalid paths removed from Git index."
echo "💡 Tip: You may want to rename or relocate those files if needed."

# Optional: show Git status and re-add everything
echo ""
read -p "🔄 Do you want to re-add all files now? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  git add .
  echo "✅ All files re-added to Git."
  git status
fi
