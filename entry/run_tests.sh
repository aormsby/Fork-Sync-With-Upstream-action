#!/bin/sh

SUCCESS_TEST_REPO="aoAppDev/action-test-access-repo.git"
TEST_ACCESS_TOKEN=$(cat ../test_key.txt)

FAIL_TEST_REPO="aoAppDev/action-test-access-fail-case.git"

echo "Running action in TEST MODE..."
. ../run/token_access.sh && run_tests
