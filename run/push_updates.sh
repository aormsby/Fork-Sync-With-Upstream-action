#!/bin/sh

# push to origin target_branch
push_new_commits() {
    write_out -1 'Pushing synced data to target branch.'

    # shellcheck disable=SC2086
    if ! git push ${INPUT_GIT_PUSH_ARGS} origin "${INPUT_TARGET_BRANCH}"; then
        # exit on push to source repo fail
        write_out "$?" "Could not push changes to source repo."
    fi
    
    write_out "g" 'SUCCESS\n'
}
