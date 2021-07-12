#!/bin/sh

# checkout target branch for updates
checkout() {
    write_out -1 "Checking out target branch '${INPUT_SOURCE_SYNC_BRANCH}' for sync."
    
    # shellcheck disable=SC2086
    if ! git checkout ${INPUT_SOURCE_BRANCH_CHECKOUT_ARGS} "${INPUT_SOURCE_SYNC_BRANCH}"; then
        # exit on branch checkout fail
        write_out "$?" "Target branch could not be checked out."
    fi

    write_out -1 "Target branch checked out"
    write_out "g" "SUCCESS\n"
}
