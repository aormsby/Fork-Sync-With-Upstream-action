#!/bin/sh

# checkout target branch for updates
checkout() {
    write_out -1 "Checking out target branch '${INPUT_TARGET_BRANCH}' for sync."
    # TODO: determine if already being on branch causes fail condition or quiet pass
    # TODO: handle checkout error, suggest to check checkout args validity
    git checkout ${INPUT_GIT_CHECKOUT_ARGS} "${INPUT_TARGET_BRANCH}" || exit 1
    write_out -1 "Target branch checked out" 1>&1
    write_out "g" "SUCCESS\n"
}
