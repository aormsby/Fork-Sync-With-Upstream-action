#!/bin/sh

# checkout target branch for updates
checkout() {
    # TODO: determine if already being on branch causes fail condition or quiet pass
    # TODO: handle checkout error, suggest to check checkout args validity
    git checkout ${INPUT_GIT_CHECKOUT_ARGS} "${INPUT_TARGET_BRANCH}" || exit 1
    echo "Target branch '${INPUT_TARGET_BRANCH}' checked out" 1>&1
}
