#!/bin/sh

# push to origin target_branch
push_new_commits() {
    write_out -1 'Pushing synced data to target branch.'

    # shellcheck disable=SC2086
    git push ${INPUT_SOURCE_PUSH_ARGS} origin "${INPUT_SOURCE_SYNC_BRANCH}"
    COMMAND_STATUS=$?

    if [ "${COMMAND_STATUS}" != 0 ]; then
        # exit on push to source repo fail
        write_out "${COMMAND_STATUS}" "Could not push changes to source repo."
    fi
    
    write_out "g" 'SUCCESS\n'
}
