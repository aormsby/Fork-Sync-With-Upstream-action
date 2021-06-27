#!/bin/sh

ERROR_NUM=0

# TODO: check validity of all inputs?
check_inputs() {
    # exit with failure if upstream_repository is not set in workflow
    check_upstream_repo
    if [ ${ERROR_NUM} = 1 ]; then
        echo 'Workflow is missing input value for "upstream_repository"' 1>&2
        echo '      example: "upstream_repository: aormsby/fork-sync-with-upstream-action"' 1>&2
        exit 1
    fi
}

# if upstream_repo input is empty, set ERROR_NUM to 1
# else, build full upstream url
check_upstream_repo() {
    if [ -z "${INPUT_UPSTREAM_REPOSITORY}" ]; then
        ERROR_NUM=1
    else
        UPSTREAM_REPO_URL="https://${GITHUB_ACTOR}:${INPUT_GITHUB_TOKEN}@github.com/${INPUT_UPSTREAM_REPOSITORY}.git"
    fi
}

# TODO: improve console output
run_tests() {
    # Test values stored in normal input vars to simplify some testing
    INPUT_GITHUB_TOKEN=${TEST_ACCESS_TOKEN}
    INPUT_UPSTREAM_REPOSITORY=${TEST_UPSTREAM_REPOSITORY}

    echo "Check inputs test 1 -> 'upstream_repository' must not be empty"
    check_upstream_repo
    
    if [ ${ERROR_NUM} = 1 ]; then
        echo "Test 1 FAILED - 'upstream_repository' has no value and is required"
    else
        echo "Test 1 PASSED"
    fi
}
