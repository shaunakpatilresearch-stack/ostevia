#!/usr/bin/env bash
# Publish ~/refix to GitHub Pages as a public repo named "ostevia".
# Run once after `gh auth login`. Re-run after edits to push updates.
set -euo pipefail
export PATH="$HOME/.local/bin:$PATH"
cd "$HOME/refix"
USER=$(gh api user -q .login)
REPO="ostevia"
if ! gh repo view "$USER/$REPO" >/dev/null 2>&1; then
  gh repo create "$USER/$REPO" --public --source=. --remote=origin --push \
    --description "Ostevia: clearance and registry for reused orthopaedic plates (prototype)"
else
  git remote get-url origin >/dev/null 2>&1 || git remote add origin "https://github.com/$USER/$REPO.git"
  git push -u origin main
fi
# Enable Pages from the main branch root (idempotent)
gh api -X POST "repos/$USER/$REPO/pages" -f 'source[branch]=main' -f 'source[path]=/' >/dev/null 2>&1 || true
echo
echo "Site: https://$USER.github.io/$REPO/   (first build takes 1-3 minutes)"
