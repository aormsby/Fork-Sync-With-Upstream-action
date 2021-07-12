#!/bin/sh

# check latest commit hashes for a match, exit if nothing to sync

check_for_updates() {
    write_out -1 'Checking for new commits on upstream branch.'

    # get latest commit hashes from local and remote branches for comparison
    # shellcheck disable=SC2086
    git fetch ${INPUT_GIT_FETCH_ARGS} upstream "${INPUT_UPSTREAM_BRANCH}"
    LOCAL_COMMIT_HASH=$(git rev-parse "${INPUT_TARGET_BRANCH}")
    UPSTREAM_COMMIT_HASH=$(git rev-parse upstream/"${INPUT_UPSTREAM_BRANCH}")

    if [ -z "${LOCAL_COMMIT_HASH}" ] || [ -z "${UPSTREAM_COMMIT_HASH}" ]; then
        HAS_NEW_COMMITS="error"
    elif [ "${LOCAL_COMMIT_HASH}" = "${UPSTREAM_COMMIT_HASH}" ]; then
        HAS_NEW_COMMITS=false
    else # assumes that remote will never be behind local when using this action...
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

# display new commits since last sync
output_new_commit_list() {
    write_out -1 'New commits since last sync:'
    # shellcheck disable=SC2086
    git log upstream/"${INPUT_UPSTREAM_BRANCH}" "${LOCAL_COMMIT_HASH}"..HEAD ${INPUT_GIT_LOG_FORMAT_ARGS}
}

# sync from upstream to target_branch
sync_new_commits() {
    write_out -1 'Syncing new commits...'

    # pull_args examples: "--ff-only", "--tags", "--ff-only --tags"
    # shellcheck disable=SC2086
    if ! git pull --no-edit ${INPUT_GIT_PULL_ARGS} upstream "${INPUT_UPSTREAM_BRANCH}"; then
        # exit on commit pull fail
        write_out "$?" "New commits could not be pulled."
    fi

    write_out "g" 'SUCCESS\n'
}
