#!/bin/sh

SUCCESS_TEST_REPO="aoAppDev/action-test-access-repo.git"
TEST_ACCESS_TOKEN=$(cat ../test_key.txt)

FAIL_TEST_REPO="aoAppDev/action-test-access-fail-case.git"

# target test values
TEST_USER_NAME="test user"
TEST_USER_EMAIL="test@email.com"
TEST_PULL_CONFIG=false

echo "Running action in TEST MODE..."
. ../run/config_git.sh && run_tests
# . ../run/token_access.sh && run_tests

# TODO: exit on test fail? easier to find fail points.
