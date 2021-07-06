#!/bin/sh

# push to origin target_branch
push_new_commits() {
    write_out -1 'Pushing synced data to target branch.' 1>&1
    (git push ${INPUT_GIT_PUSH_ARGS} origin "${INPUT_TARGET_BRANCH}" &&
        write_out "g" 'SUCCESS\n' 1>&1) ||
        # TODO: handle better
        write_out "r" 'Push fail'
}
