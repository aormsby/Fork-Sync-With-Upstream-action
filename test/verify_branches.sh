#!/bin/sh

# TODO: extract test passes/fails into separate script/func
# TODO: clear up output
test_target_branch_exists() {
    echo "Repo/branch test 1 -> target_branch must exist"
    VERIFY_TARGET_BRANCH=$(git rev-parse --verify "refs/heads/${INPUT_TARGET_BRANCH}")

    if [ -z "${VERIFY_TARGET_BRANCH}" ]; then
        echo "Test 1 FAILED - no branch '${INPUT_TARGET_BRANCH}' to sync"
    else
        echo "Test 1 PASSED"
    fi
}

test_upstream_repo_exists() {
    echo "Repo/branch test 2 -> upstream_repository must exist"
    VERIFY_TARGET_REPO=$(git ls-remote "${UPSTREAM_REPO_URL}")

    if [ -z "${VERIFY_TARGET_REPO}" ]; then
        echo "Test 2 FAILED - Repo '${INPUT_UPSTREAM_REPOSITORY}' not found or you do not have permission to view it"
    else
        echo "Test 2 PASSED"
    fi

}

test_upstream_branch_exists() {
    echo "Repo/branch test 3 -> upstream_branch must exist"
    VERIFY_UPSTREAM_BRANCH=$(git ls-remote "${UPSTREAM_REPO_URL}" --refs "${INPUT_UPSTREAM_BRANCH}")

    if [ -z "${VERIFY_UPSTREAM_BRANCH}" ]; then
        echo "Test 3 FAILED - no branch '${INPUT_UPSTREAM_BRANCH}' found on remote repo"
    else
        echo "Test 3 PASSED"
    fi
}
