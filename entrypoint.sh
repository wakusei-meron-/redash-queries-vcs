#!/bin/sh -l

git config user.name "${GITHUB_USER:-vesrioning redash user}"
git config user.email "${GITHUB_EMAIL:-redash-versioning-queries@users.noreply.github.com'}"

echo "export queries..."
python query_export.py --redash-url "${INPUT_ADDRESS}" --api-key "${INPUT_API_KEY}"


git add .

if [ -n "$(git diff --cached --name-only)" ]; then
  INPUT_FORCE=${INPUT_FORCE:-false}
  INPUT_TAGS=${INPUT_TAGS:-false}
  INPUT_DIRECTORY=${INPUT_DIRECTORY:-'.'}
  _FORCE_OPTION=''
  REPOSITORY=${INPUT_REPOSITORY:-$GITHUB_REPOSITORY}

  echo "Push to branch $INPUT_BRANCH";
  [ -z "${INPUT_GITHUB_TOKEN}" ] && {
      echo 'Missing input "github_token: ${{ secrets.GITHUB_TOKEN }}".';
      exit 1;
  };

  if ${INPUT_FORCE}; then
      _FORCE_OPTION='--force'
  fi

  if ${INPUT_TAGS}; then
      _TAGS='--tags'
  fi

  cd ${INPUT_DIRECTORY}

  git commit -m "update: $(date +%FT%R)"

  remote_repo="https://${GITHUB_ACTOR}:${INPUT_GITHUB_TOKEN}@github.com/${REPOSITORY}.git"
  git push "${remote_repo}" HEAD:${INPUT_BRANCH} --follow-tags $_FORCE_OPTION $_TAGS;
fi

