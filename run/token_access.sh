#!/bin/sh

# TODO: rename file based on action/purpose
# TODO: extract user-adjustable vars into superscript for test runs


# TODO:improve console output
# Run with local test values - adjustable in `entry/run_tests.sh`
run_tests() {
    echo "Token access test 1 -> Try to clone private repo with no access token / git clone should fail"
    (git clone https://github.com/${FAIL_TEST_REPO} && \
    # (git clone https://github.com/aoAppDev/action-test-access-fail-case.git && \
        echo "Test 1 FAIL - git clone should failed") || \
        echo "Test 1 PASSED - git clone failed as expected"

    echo "Token access test 2 -> Try to clone private repo with access token / git clone should succeed"
    (git clone https://${TEST_ACCESS_TOKEN}@github.com/${SUCCESS_TEST_REPO} && \
    # (git clone https://${INPUT_GITHUB_TOKEN}@github.com/aoAppDev/action-test-access-repo.git && \
        echo "Test 2 PASSED - git clone succeeded as expected") || \
        echo "Test 2 FAILED - git clone should have succeeded"

    # TODO: clean up cloned repo (now? or after later tests?)
}
