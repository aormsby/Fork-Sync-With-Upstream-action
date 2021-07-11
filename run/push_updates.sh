#!/bin/sh

# push to origin target_branch
push_new_commits() {
    write_out -1 'Pushing synced data to target branch.'
    (git push ${INPUT_GIT_PUSH_ARGS} origin "${INPUT_TARGET_BRANCH}" &&
        write_out "g" 'SUCCESS\n')

    # exit on push to source repo fail
    if [ "$?" != 0 ]; then
        write_out "$?" "Could not push changes to source repo."
    fi
}
