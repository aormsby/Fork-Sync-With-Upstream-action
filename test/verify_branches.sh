#!/bin/sh

# TODO: extract test passes/fails into separate script/func
test_target_branch_exists() {
    # TODO: change text based on final var name
    echo "TEST [Verify Target Sync Branch] -> target_branch must exist"
    VERIFY_TARGET_BRANCH=$(git rev-parse --verify "refs/heads/${INPUT_TARGET_BRANCH}")

    if [ -z "${VERIFY_TARGET_BRANCH}" ]; then
        echo "FAILED - no branch '${INPUT_TARGET_BRANCH}' to run action on\n"
    else
        echo "PASSED\n"
    fi
}

test_upstream_repo_exists() {
    echo "TEST [Verify Upstream Repo Exists] -> upstream_repository must exist"
    VERIFY_TARGET_REPO=$(git ls-remote "${UPSTREAM_REPO_URL}")

    if [ -z "${VERIFY_TARGET_REPO}" ]; then
        echo "FAILED - Upstream repo '${INPUT_UPSTREAM_REPOSITORY}' not found OR you do not have permission to view it\n"
    else
        echo "PASSED\n"
    fi

}

test_upstream_branch_exists() {
    echo "TEST [Verify Upstream Branch] -> upstream_branch must exist"
    VERIFY_UPSTREAM_BRANCH=$(git ls-remote "${UPSTREAM_REPO_URL}" --refs "${INPUT_UPSTREAM_BRANCH}")

    if [ -z "${VERIFY_UPSTREAM_BRANCH}" ]; then
        echo "Test 3 FAILED - no branch '${INPUT_UPSTREAM_BRANCH}' found on remote repo\n"
    else
        echo "PASSED\n"
    fi
}
