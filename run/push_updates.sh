#!/bin/sh

# push to origin target_sync_branch
push_new_commits() {
    write_out -1 'Pushing synced data to target branch.'

    # TODO: figure out how this would work in local mode...
    # update origin url with token since it is not necessarily persisted during checkout step
    git remote set-url origin "https://${GITHUB_ACTOR}:${INPUT_TARGET_REPO_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"

    # shellcheck disable=SC2086
    git push ${INPUT_TARGET_PUSH_ARGS} origin "${INPUT_TARGET_SYNC_BRANCH}"
    COMMAND_STATUS=$?

    if [ "${COMMAND_STATUS}" != 0 ]; then
        # exit on push to target repo fail
        write_out "${COMMAND_STATUS}" "Could not push changes to target repo."
    fi
    
    write_out "g" 'SUCCESS\n'
}
