#!/bin/sh
set -eu

if [ -z "${GITHUB_PROJECT_NAME:-''}" ] || [ -z "${GITHUB_ORG_NAME:-''}" ]; then
  echo >&2 "Missing GITHUB_PROJECT_NAME or GITHUB_ORG_NAME in environment."
  exit 1
fi

if ! git status -s >/dev/null 2>&1; then
  echo >&2 "Uncommitted changes detected, exiting."
  exit 1
fi


find . \( -type d -name .git -prune \) -o -type f -print0 | LC_ALL=C xargs -0 sed -i '' 's/@@MYPROJECT@@/'"$GITHUB_PROJECT_NAME"'/'

find . \( -type d -name .git -prune \) -o -type f -print0 | LC_ALL=C xargs -0 sed -i '' 's/@@MYORG@@/'"$GITHUB_ORG_NAME"'/'

mv myapp.spec "${GITHUB_PROJECT_NAME,,}.spec"
mv myapp "${GITHUB_PROJECT_NAME}"

echo "Finished renmaing template; removing $0"
rm -f "$0" && git rm "$0"


