#!/bin/sh

# push to origin source_sync_branch
push_new_commits() {
    write_out -1 'Pushing synced data to source branch.'

    # TODO: figure out hwo this would work in local mode...
    # update origin url with token since it is not persisted during checkout step when syncing from a private repo
    if [ -n "${INPUT_UPSTREAM_REPO_ACCESS_TOKEN}" ]; then
        echo "github token - ${INPUT_SOURCE_REPO_TOKEN}"
        git remote set-url origin "https://${GITHUB_ACTOR}:${INPUT_SOURCE_REPO_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
    fi

    # shellcheck disable=SC2086
    git push ${INPUT_SOURCE_PUSH_ARGS} origin "${INPUT_SOURCE_SYNC_BRANCH}"
    COMMAND_STATUS=$?

    if [ "${COMMAND_STATUS}" != 0 ]; then
        # exit on push to source repo fail
        write_out "${COMMAND_STATUS}" "Could not push changes to source repo."
    fi
    
    write_out "g" 'SUCCESS\n'
}
