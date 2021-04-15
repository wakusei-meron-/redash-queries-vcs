#!/bin/sh -l

git config user.name "${GITHUB_USER}"
git config user.email "${GITHUB_EMAIL}"

echo "export queries..."
python query_export.py --redash-url "${INPUT_ADDRESS}" --api-key "${INPUT_API_KEY}"

git add .

if [ -n "$(git diff --cached --name-only)" ]; then
  current_branch=${GITHUB_REF#refs/heads/}
  echo ${current_branch}

  remote_repo="https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
  git commit -m "update: $(date +%FT%R)"
  git push ${remote_repo}
fi

