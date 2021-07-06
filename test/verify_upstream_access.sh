#!/bin/sh

TEST_CLONE_DIR="test-clone-dir"
SKIP_CLEANUP=false

# TODO:improve console output
test_has_upstream_repo_access() {
    echo "TEST [Upstream Repo Access] -> Try to clone private repo with access token / git clone should succeed"

    git clone --quiet --depth 1 "${UPSTREAM_REPO_URL}" "${TEST_CLONE_DIR}"
    COMMAND_EXIT_CODE=$?
    
    if [ "${COMMAND_EXIT_CODE}" -eq "0" ]; then
        echo "PASSED"   # no \n because of cleanup output
    else
        echo "Test 1 FAILED - repo does not exist OR you do not have permission to clone from it\n"
        SKIP_CLEANUP=true
    fi
}

# remove test directory after clone is complete
cleanup_test_dir() {
    if [ "${SKIP_CLEANUP}" = true ]; then
        true;
    else
        (rm -rf "${TEST_CLONE_DIR}" &&
            echo "Clone cleanup successful.\n") ||
            echo "Clone cleanup failed - please find and remove directory '${TEST_CLONE_DIR}'\n"
    fi
}
