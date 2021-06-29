#!/bin/sh

TEST_CLONE_DIR="test-clone-dir"
SKIP_CLEANUP=false

# TODO:improve console output
test_has_upstream_repo_access() {
    echo "Upstream repo access test 1 -> Try to clone private repo with access token / git clone should succeed"

    git clone --quiet --depth 1 "${UPSTREAM_REPO_URL}" "${TEST_CLONE_DIR}"
    COMMAND_EXIT_CODE=$?
    
    if [ "${COMMAND_EXIT_CODE}" -eq "0" ]; then
        echo "Test 1 PASSED - git clone test succeeded as expected"
    else
        echo "Test 1 FAILED - git clone test failed"
        SKIP_CLEANUP=true
    fi
}

# remove test directory after clone is complete
cleanup_test_dir() {
    if [ "${SKIP_CLEANUP}" = true ]; then
        echo "skipping clone cleanup step"
    else
        (rm -rf "${TEST_CLONE_DIR}" &&
            echo "test clone cleanup successful") ||
            echo "test clone cleanup failed - be sure to remove directory '${TEST_CLONE_DIR}'"
    fi
}
