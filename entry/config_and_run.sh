#!/bin/sh

# source script to handle message output
. ../util/output.sh

# TODO: SPIKE on 'live' tests through the action runner
if [ -z "${GITHUB_ACTIONS}" ] || [ "${GITHUB_ACTIONS}" = false ]; then
    write_out "b" "\nRunning in LOCAL MODE..."

    # set test mode, default false
    INPUT_TEST_MODE=false

    # region vars
    # Github login of the user initiating the workflow run
    GITHUB_ACTOR="aormsby"
    
    # required vars (except token)
    INPUT_SOURCE_SYNC_BRANCH="master"
    INPUT_UPSTREAM_REPO_ACCESS_TOKEN="$(cat ../test_key.txt)"
    INPUT_UPSTREAM_SYNC_REPO="aoAppDev/action-test-access-repo"
    INPUT_UPSTREAM_SYNC_BRANCH="main"
    
    # optional vars (except token)
    INPUT_SOURCE_BRANCH_CHECKOUT_ARGS=""
    INPUT_GIT_LOG_FORMAT_ARGS="--pretty=oneline"
    INPUT_UPSTREAM_PULL_ARGS=""
    INPUT_SOURCE_PUSH_ARGS=""
    
    # git config vars - required if they aren't already set
    # TODO: change project name to upstream sync
    INPUT_GIT_CONFIG_USER="GH Action - Upstream Sync"
    INPUT_GIT_CONFIG_EMAIL="action@github.com"
    INPUT_GIT_CONFIG_PULL_REBASE=false
    # endregion
fi

UPSTREAM_REPO_URL="https://${GITHUB_ACTOR}:${INPUT_UPSTREAM_REPO_ACCESS_TOKEN}@github.com/${INPUT_UPSTREAM_SYNC_REPO}.git"

# Fork to live action or test mode based on INPUT_TEST_MODE flag
if [ "${INPUT_TEST_MODE}" = true ]; then
    write_out "b" "Running TESTS...\n"
    . ./run_tests.sh
    write_out "b" "Tests Complete"
else
    write_out "b" "Running ACTION...\n"
    . ./run_action.sh
    write_out "b" "Action Complete"
fi

: '
TODO: determine best method for users to run this locally:
 - place project inside the target repo?
 - add var for path to repo?
 - perform target repo checkout inside this project to perform actions?
'
