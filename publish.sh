#!/usr/bin/env bash
# One-command publish to GitHub Pages. Usage: bash publish.sh [repo-name]
set -e
REPO="${1:-My-Shelf}"
[ -d .git ] || git init -b main
git add -A && (git commit -m "Update My Shelf" || true)
git branch -M main
if ! git remote get-url origin >/dev/null 2>&1; then
  if command -v gh >/dev/null; then gh repo create "$REPO" --public --source=. --remote=origin
  else echo "No remote yet. Run: git remote add origin https://github.com/YOUR-USERNAME/$REPO.git  then run this script again."; exit 1; fi
fi
git push -u origin main
if command -v gh >/dev/null; then
  USER=$(gh api user -q .login)
  gh api -X POST "repos/$USER/$REPO/pages" -f "source[branch]=main" -f "source[path]=/" >/dev/null 2>&1 || true
  echo "Live in about a minute: https://$USER.github.io/$REPO/"
else echo "Now open the repo on GitHub: Settings -> Pages -> Deploy from branch -> main -> / (root)."; fi
