#!/bin/sh

: '
TODO: determine best method for users to run this locally:
 - place project inside the target repo?
 - add var for path to repo?
 - perform target repo checkout inside this project to perform actions?
'

# get action directory for sourcing subscripts
ACTION_PARENT_DIR=$(dirname "$(dirname "$0")")

# shellcheck disable=SC1091
# source script to handle message output
. "${ACTION_PARENT_DIR}"/util/output.sh

if [ -z "${GITHUB_ACTIONS}" ] || [ "${GITHUB_ACTIONS}" = false ]; then
    write_out "b" "\nRunning in LOCAL MODE..."

    # set test mode, default false
    INPUT_TEST_MODE=true

    # TODO: figure out good local mode defaults

    # region vars
    # Github username of the user initiating the workflow run
    GITHUB_ACTOR=""
    # Access token for authenticating commands in the target repo
    # shellcheck disable=SC2034
    INPUT_TARGET_REPO_TOKEN=""
    # shellcheck disable=SC2034
    GITHUB_REPOSITORY=""
    
    # required vars (except token)
    # shellcheck disable=SC2034
    INPUT_TARGET_SYNC_BRANCH="main"
    # create a local file to store your access token if you wish to use/test locally
    INPUT_UPSTREAM_REPO_ACCESS_TOKEN="$(cat "${ACTION_PARENT_DIR}"/test_key.txt)"
    INPUT_UPSTREAM_SYNC_REPO="aoAppDev/action-test-access-repo"
    # shellcheck disable=SC2034
    INPUT_UPSTREAM_SYNC_BRANCH="main"
    
    # optional vars (except token)
    # shellcheck disable=SC2034
    INPUT_TARGET_BRANCH_CHECKOUT_ARGS=""
    # shellcheck disable=SC2034
    INPUT_GIT_LOG_FORMAT_ARGS="--pretty=oneline"
    # shellcheck disable=SC2034
    INPUT_UPSTREAM_PULL_ARGS=""
    # shellcheck disable=SC2034
    INPUT_TARGET_BRANCH_PUSH_ARGS=""
    
    # git config vars - required if they aren't already set
    # shellcheck disable=SC2034
    INPUT_GIT_CONFIG_USER="GH Action - Upstream Sync"
    # shellcheck disable=SC2034
    INPUT_GIT_CONFIG_EMAIL="action@github.com"
    # shellcheck disable=SC2034
    INPUT_GIT_CONFIG_PULL_REBASE=false
    # endregion

    INPUT_HOST_DOMAIN='github.com'
fi

if [ -z "${INPUT_UPSTREAM_REPO_ACCESS_TOKEN}" ]; then
    # shellcheck disable=SC2034
    UPSTREAM_REPO_URL="https://${INPUT_HOST_DOMAIN}/${INPUT_UPSTREAM_SYNC_REPO}.git"
else
    # shellcheck disable=SC2034
    UPSTREAM_REPO_URL="https://${GITHUB_ACTOR}:${INPUT_UPSTREAM_REPO_ACCESS_TOKEN}@${INPUT_HOST_DOMAIN}/${INPUT_UPSTREAM_SYNC_REPO}.git"
fi

# Fork to live action or test mode based on INPUT_TEST_MODE flag
if [ "${INPUT_TEST_MODE}" = true ]; then
    write_out "b" "Running TESTS...\n"
    # shellcheck disable=SC1091
    . "${ACTION_PARENT_DIR}"/entry/run_tests.sh
    write_out "b" "Tests Complete"
else
    write_out "b" "Running ACTION...\n"
    # shellcheck disable=SC1091
    . "${ACTION_PARENT_DIR}"/entry/run_action.sh
    write_out "b" "Action Complete"
fi
