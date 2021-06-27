#!/bin/sh

# The Github login of the user initiating the workflow run
GITHUB_ACTOR='aormsby'

# TODO: organize and comment test values
SUCCESS_TEST_REPO="aoAppDev/action-test-access-repo.git"
# Reading token from external file to prevent pushing to remote repository
TEST_ACCESS_TOKEN=$(cat ../test_key.txt)
FAIL_TEST_REPO="aoAppDev/action-test-access-fail-case.git"

# target test values
TEST_USER_NAME="test user"
TEST_USER_EMAIL="test@email.com"
TEST_PULL_CONFIG=false

TEST_UPSTREAM_REPOSITORY="aormsby/Fork-Sync-With-Upstream-action"

TEST_TARGET_BRANCH="master"
TEST_UPSTREAM_BRANCH="main"

TEST_CHECKOUT_ARGS=""
TEST_GIT_FETCH_ARGS=""
TEST_GIT_LOG_FORMAT_ARGS="--pretty=oneline"
TEST_GIT_PULL_ARGS=""

# Run test scripts
echo "Running action in TEST MODE..."
. ../run/check_action_inputs.sh && run_tests
. ../run/config_git.sh && run_tests
. ../run/checkout_branch.sh && run_tests
. ../run/set_upstream_repo && run_tests
# . ../run/get_updates.sh && run_tests
# . ../run/token_access.sh && run_tests

# cleanup
. ../run/set_upstream_repo && unset_upstream

# TODO: exit on test fail? easier to find fail points.
