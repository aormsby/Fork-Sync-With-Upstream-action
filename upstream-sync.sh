#!/bin/sh

set -e
# do not quote GIT_PULL_ARGS or GIT_*_ARGS. As they may contain
# more than one argument.

# set user credentials in git config
if [ "${INPUT_CONFIG_GIT_CREDENTIALS}" = true ]; then
    # store original for reset later
    ORIG_USER=git config --global --get user.name
    ORIG_EMAIL=git config --global --get user.email

    git config --global user.name "${INPUT_GIT_EMAIL}"
    git config --global user.email "${INPUT_GIT_USER}"

    echo 'Git user and email credentials set for action' 1>&1
fi

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
    git checkout ${INPUT_GIT_CHECKOUT_ARGS} "${INPUT_TARGET_BRANCH}"
    echo 'Target branch ' ${INPUT_TARGET_BRANCH} ' checked out' 1>&1
fi

# set upstream to upstream_repository
git remote add upstream "${UPSTREAM_REPO}"

# check remotes in case of error
# git remote -v

# check latest commit hashes for a match, exit if nothing to sync
git fetch ${INPUT_GIT_FETCH_ARGS} upstream "${INPUT_UPSTREAM_BRANCH}"
LOCAL_COMMIT_HASH=$(git rev-parse "${INPUT_TARGET_BRANCH}")
UPSTREAM_COMMIT_HASH=$(git rev-parse upstream/"${INPUT_UPSTREAM_BRANCH}")

if [ "${LOCAL_COMMIT_HASH}" = "${UPSTREAM_COMMIT_HASH}" ]; then
    echo "::set-output name=has_new_commits::false"
    echo 'No new commits to sync, exiting' 1>&1
    exit 0
fi

echo "::set-output name=has_new_commits::true"
# display commits since last sync
echo 'New commits being synced:' 1>&1
git log upstream/"${INPUT_UPSTREAM_BRANCH}" "${LOCAL_COMMIT_HASH}"..HEAD ${INPUT_GIT_LOG_FORMAT_ARGS}

# sync from upstream to target_branch
echo 'Syncing...' 1>&1
# pull_args examples: "--ff-only", "--tags"
git pull ${INPUT_GIT_PULL_ARGS} upstream "${INPUT_UPSTREAM_BRANCH}"
echo 'Sync successful' 1>&1

# push to origin target_branch
echo 'Pushing to target branch...' 1>&1
git push ${INPUT_GIT_PUSH_ARGS} origin "${INPUT_TARGET_BRANCH}"
echo 'Push successful' 1>&1


# reset user credentials for future actions
if [ "${INPUT_CONFIG_GIT_CREDENTIALS}" = true ]; then
    git config --global user.name "${ORIG_USER}"
    git config --global user.email "${ORIG_EMAIL}"
    
    echo 'Git user name and email credentials reset to original state' 1>&1
fi