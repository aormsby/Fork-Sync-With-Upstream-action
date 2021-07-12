#!/bin/sh

# checkout target branch for updates
checkout() {
    write_out -1 "Checking out target branch '${INPUT_TARGET_BRANCH}' for sync."
    
    # shellcheck disable=SC2086
    if ! git checkout ${INPUT_GIT_CHECKOUT_ARGS} "${INPUT_TARGET_BRANCH}"; then
        # exit on branch checkout fail
        write_out "$?" "Target branch could not be checked out."
    fi

    write_out -1 "Target branch checked out"
    write_out "g" "SUCCESS\n"
}
