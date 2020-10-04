#!/bin/sh

set -e

# fail if upstream_repository is not set in workflow
if [ -z "${INPUT_UPSTREAM_REPOSITORY}" ]; then
    echo 'Workflow missing input value for "upstream_repository"' 1>&2
    echo '      example: "upstream_repository: aormsby/fork-sync-with-upstream-action"' 1>&2
    exit 1
else
    UPSTREAM_REPO="https://${GITHUB_ACTOR}:${INPUT_GITHUB_TOKEN}@github.com/${INPUT_UPSTREAM_REPOSITORY}.git"
fi

# ensure target_branch is checked out
if [ $(git branch --show-current) != "${INPUT_TARGET_BRANCH}" ]; then
    git checkout "${INPUT_TARGET_BRANCH}"
    echo 'Target branch ' ${INPUT_TARGET_BRANCH} ' checked out' 1>&1
fi

# set upstream to upstream_repository
git remote add upstream "${UPSTREAM_REPO}"

# check remotes in case of error
# git remote -v

# check latest commit hashes for a match, exit if nothing to sync
git fetch upstream "${INPUT_UPSTREAM_BRANCH}"
LOCAL_COMMIT_HASH=$(git rev-parse "${INPUT_TARGET_BRANCH}")
UPSTREAM_COMMIT_HASH=$(git rev-parse upstream/"${INPUT_UPSTREAM_BRANCH}")

if [ "${LOCAL_COMMIT_HASH}" = "${UPSTREAM_COMMIT_HASH}" ]; then
    echo "::set-output name=has_new_commits::false"
    echo 'No new commits to sync, exiting' 1>&1
    exit 0
fi

echo "::set-output name=has_new_commits::true"
# display commits since last sync
echo 'New commits being pulled:' 1>&1
git log upstream/"${INPUT_UPSTREAM_BRANCH}" "${LOCAL_COMMIT_HASH}"..HEAD --pretty=oneline

# pull from upstream to target_branch
echo 'Pulling...' 1>&1
git pull upstream "${INPUT_UPSTREAM_BRANCH}"
echo 'Pull successful' 1>&1

# push to origin target_branch
echo 'Pushing to target branch...' 1>&1
git push origin "${INPUT_TARGET_BRANCH}"
echo 'Push successful' 1>&1
