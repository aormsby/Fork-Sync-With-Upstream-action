#!/bin/sh

TEST_CLONE_DIR="fork-action-test-clone-dir"
SKIP_CLEANUP=false

# in case test dir already exits, delete it
pretest_remove_dir() {
    rm -rf "${TEST_CLONE_DIR}"
}

test_has_upstream_repo_access() {
    pretest_remove_dir

    write_out "y" "TEST"
    write_out -1 "[Upstream Repo Access] -> Try to clone private repo with access token / git clone should succeed"

    git clone --quiet --depth 1 "${UPSTREAM_REPO_URL}" "${TEST_CLONE_DIR}"
    COMMAND_EXIT_CODE=$?

    if [ "${COMMAND_EXIT_CODE}" -eq "0" ]; then
        write_out "g" "PASSED" # no \n because of cleanup output
    else
        write_out "r" "FAILED - repo does not exist OR you do not have permission to clone from it\n"
        SKIP_CLEANUP=true
    fi
}

# remove test directory after clone is complete
cleanup_test_dir() {
    if [ "${SKIP_CLEANUP}" = true ]; then
        true # no-op skip
    else
        rm -rf "${TEST_CLONE_DIR}"
        COMMAND_STATUS=$?

        # warn if cloned test directory can't be removed
        if [ "${COMMAND_STATUS}" != 0 ] ; then
            write_out "r" "(Clone cleanup failed - please find and remove directory '${TEST_CLONE_DIR}')\n"
        else
            write_out -1 "(Clone directory cleanup successful.)\n"
        fi
    fi
}
