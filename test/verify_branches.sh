#!/bin/sh

test_target_branch_exists() {
    write_out "y" "TEST"
    # TODO: change displayed input var names based on final revisions
    write_out -1 "[Verify Target Sync Branch] -> target_branch must exist"
    VERIFY_TARGET_BRANCH=$(git rev-parse --verify "refs/heads/${INPUT_SOURCE_SYNC_BRANCH}")

    if [ -z "${VERIFY_TARGET_BRANCH}" ]; then
        write_out "r" "FAILED - no branch '${INPUT_SOURCE_SYNC_BRANCH}' to run action on\n"
    else
        write_out "g" "PASSED\n"
    fi
}

test_upstream_repo_exists() {
    write_out "y" "TEST"
    write_out -1 "[Verify Upstream Repo Exists] -> upstream_repository must exist"
    VERIFY_TARGET_REPO=$(git ls-remote "${UPSTREAM_REPO_URL}")

    if [ -z "${VERIFY_TARGET_REPO}" ]; then
        write_out "r" "FAILED - Upstream repo '${INPUT_UPSTREAM_SYNC_REPO}' not found OR you do not have permission to view it\n"
    else
        write_out "g" "PASSED\n"
    fi

}

test_upstream_branch_exists() {
    write_out "y" "TEST"
    write_out -1 "[Verify Upstream Branch] -> upstream_branch must exist"
    VERIFY_UPSTREAM_BRANCH=$(git ls-remote "${UPSTREAM_REPO_URL}" --refs "${INPUT_UPSTREAM_SYNC_BRANCH}")

    if [ -z "${VERIFY_UPSTREAM_BRANCH}" ]; then
        write_out "r" "Test 3 FAILED - no branch '${INPUT_UPSTREAM_SYNC_BRANCH}' found on remote repo\n"
    else
        write_out "g" "PASSED\n"
    fi
}
