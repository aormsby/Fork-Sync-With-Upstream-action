#!/bin/sh

# checkout target branch for updates
checkout() {
    write_out -1 "Checking out target branch '${INPUT_TARGET_SYNC_BRANCH}' for sync."

    # shellcheck disable=SC2086
    git checkout ${INPUT_TARGET_BRANCH_CHECKOUT_ARGS} "${INPUT_TARGET_SYNC_BRANCH}"
    COMMAND_STATUS=$?

    if [ "${COMMAND_STATUS}" != 0 ]; then
        # exit on branch checkout fail
        write_out "${COMMAND_STATUS}" "Target branch '${INPUT_TARGET_SYNC_BRANCH}' could not be checked out."
    fi

    write_out -1 "Target branch checked out"
    write_out "g" "SUCCESS\n"
}
