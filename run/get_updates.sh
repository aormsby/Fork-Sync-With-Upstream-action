#!/bin/sh

# shellcheck disable=SC2086

# check latest commit hashes for a match, exit if nothing to sync
check_for_updates() {
    write_out -1 'Checking for new commits on upstream branch.\n'

    # get latest commit hashes from local and remote branches for comparison
    git fetch --depth=1 upstream "${INPUT_UPSTREAM_SYNC_BRANCH}"
    # TODO: remove me?
    # LOCAL_COMMIT_HASH=$(git rev-parse "${INPUT_TARGET_SYNC_BRANCH}")
    UPSTREAM_COMMIT_HASH=$(git rev-parse "upstream/${INPUT_UPSTREAM_SYNC_BRANCH}")

    git fetch --shallow-since="1 week ago" origin "${INPUT_TARGET_SYNC_BRANCH}"
    BRANCH_WITH_LATEST="$(git branch "${INPUT_TARGET_SYNC_BRANCH}" --contains="${UPSTREAM_COMMIT_HASH}")"

    if [ -z "${UPSTREAM_COMMIT_HASH}" ]; then
        HAS_NEW_COMMITS="error"
    elif [ -n "${BRANCH_WITH_LATEST}" ]; then
        HAS_NEW_COMMITS=false
    else
        HAS_NEW_COMMITS=true
    fi

    # output 'has_new_commits' value to workflow environment
    echo "::set-output name=has_new_commits::${HAS_NEW_COMMITS}"

    # early exit if no new commits or something failed
    if [ "${HAS_NEW_COMMITS}" = false ]; then
        exit_no_commits
    elif [ "${HAS_NEW_COMMITS}" = "error" ]; then
        write_out 95 'There was an error checking for new commits.'
    fi
}

exit_no_commits() {
    write_out 0 'No new commits to sync. Finishing sync action gracefully.'
}

# TODO: fix log output
# display new commits since last sync
output_new_commit_list() {
    write_out -1 '\nNew commits since last sync:'
    git log upstream/"${INPUT_UPSTREAM_SYNC_BRANCH}" "${LOCAL_COMMIT_HASH}"..HEAD ${INPUT_GIT_LOG_FORMAT_ARGS}
}

# sync from upstream to target_sync_branch
sync_new_commits() {
    write_out -1 '\nSyncing new commits...'

    # pull_args examples: "--ff-only", "--tags", "--ff-only --tags"
    git pull --no-edit ${INPUT_UPSTREAM_PULL_ARGS} upstream "${INPUT_UPSTREAM_SYNC_BRANCH}"
    COMMAND_STATUS=$?

    if [ "${COMMAND_STATUS}" != 0 ]; then
        # exit on commit pull fail
        write_out "${COMMAND_STATUS}" "New commits could not be pulled."
    fi

    write_out "g" 'SUCCESS\n'
}
