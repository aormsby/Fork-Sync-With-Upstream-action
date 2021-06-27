#!/bin/sh

# ensure target_branch is checked out

checkout() {
    # TODO: determine if already being on branch causes fail condition or quiet pass
    # TODO: handle checkout error, suggest to check checkout args validity
    git checkout ${INPUT_GIT_CHECKOUT_ARGS} "${INPUT_TARGET_BRANCH}" || exit 1
    echo "Target branch '${INPUT_TARGET_BRANCH}' checked out" 1>&1
}

run_tests() {
    echo "Checkout target branch test 1 -> branch must exist"
    VERIFY_TARGET_BRANCH=$(git rev-parse --verify "refs/heads/${TEST_TARGET_BRANCH}")
    if [ -z ${VERIFY_TARGET_BRANCH} ]; then
         echo "Test 1 FAILED - no branch '${TEST_TARGET_BRANCH}' to checkout"
    else
         echo "Test 1 PASSED"
    fi

    # note - cannot test validity of git checkout args
}
