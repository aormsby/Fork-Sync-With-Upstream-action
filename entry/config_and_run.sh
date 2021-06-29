#!/bin/sh

# TODO: SPIKE on 'live' tests through the action runner
# TODO: set -e?? -- no, please handle all errors && exits
if [ -z "${GITHUB_ACTIONS}" ] || [ "${GITHUB_ACTIONS}" = false ]; then
    echo "Running in LOCAL MODE..."

    # TODO: set test mode in the yaml workflow
    # set test mode here
    INPUT_TEST_MODE=true

    # region vars
    # TODO: explain local var settings use here
    # The Github login of the user initiating the workflow run
    GITHUB_ACTOR="aormsby"
    INPUT_GITHUB_TOKEN="$(cat ../test_key.txt)"
    INPUT_UPSTREAM_BRANCH="main"
    INPUT_UPSTREAM_REPOSITORY="aoAppDev/action-test-access-repo"
    INPUT_TARGET_BRANCH="master"
    # TODO: perhaps make args input use location more clear
    INPUT_GIT_CHECKOUT_ARGS=""
    INPUT_GIT_FETCH_ARGS=""
    INPUT_GIT_LOG_FORMAT_ARGS="--pretty=oneline"
    INPUT_GIT_PULL_ARGS=""
    INPUT_GIT_PUSH_ARGS=""
    # TODO: update all var names in action.yaml
    INPUT_GIT_CONFIG_EMAIL="action@github.com"
    # TODO: change project name to upstream sync
    INPUT_GIT_CONFIG_USER="GH Action - Upstream Sync"
    # TODO: remove quotes?
    INPUT_GIT_CONFIG_PULL_REBASE="false"
    # endregion
fi

UPSTREAM_REPO_URL="https://${GITHUB_ACTOR}:${INPUT_GITHUB_TOKEN}@github.com/${INPUT_UPSTREAM_REPOSITORY}.git"

if [ "${INPUT_TEST_MODE}" = true ]; then
    . ./run_tests.sh
else
    . ./run_action.sh
fi

: '
TODO: determine best method for users to run this locally:
 - place project inside the target repo?
 - add var for path to repo?
 - perform target repo checkout inside this project to perform actions?
'
