#!/bin/sh

# shellcheck disable=SC2086

# check latest commit hashes for a match, exit if nothing to sync
check_for_updates() {
    write_out -1 'Checking for new commits on upstream branch.\n'

    # fetch commits from upstream branch within given time frame (default 1 month)
    git fetch --quiet --shallow-since="${INPUT_SHALLOW_SINCE}" upstream "${INPUT_UPSTREAM_SYNC_BRANCH}"
    COMMAND_STATUS=$?

    if [ "${COMMAND_STATUS}" != 0 ]; then
        # if shallow fetch fails, no new commits are avilable for sync
        HAS_NEW_COMMITS=false
        set_out_put
        exit_no_commits
    fi

    UPSTREAM_COMMIT_HASH=$(git rev-parse "upstream/${INPUT_UPSTREAM_SYNC_BRANCH}")

    # check is latest upstream hash is in target branch
    git fetch --quiet --shallow-since="${INPUT_SHALLOW_SINCE}" origin "${INPUT_TARGET_SYNC_BRANCH}"
    BRANCH_WITH_LATEST="$(git branch "${INPUT_TARGET_SYNC_BRANCH}" --contains="${UPSTREAM_COMMIT_HASH}")"

    if [ -z "${UPSTREAM_COMMIT_HASH}" ]; then
        HAS_NEW_COMMITS="error"
    elif [ -n "${BRANCH_WITH_LATEST}" ]; then
        HAS_NEW_COMMITS=false
    else
        HAS_NEW_COMMITS=true
    fi

    # output 'has_new_commits' value to workflow environment
    set_out_put

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

set_out_put() {
    echo "has_new_commits=${HAS_NEW_COMMITS}" >> $GITHUB_OUTPUT
}

find_last_synced_commit() {
    LAST_SYNCED_COMMIT=""
    TARGET_BRANCH_LOG="$(git rev-list "${INPUT_TARGET_SYNC_BRANCH}")"
    UPSTREAM_BRANCH_LOG="$(git rev-list "upstream/${INPUT_UPSTREAM_SYNC_BRANCH}")"

    for hash in ${TARGET_BRANCH_LOG}; do
        UPSTREAM_CHECK="$(echo "${UPSTREAM_BRANCH_LOG}" | grep "${hash}")"
        if [ -n "${UPSTREAM_CHECK}" ]; then
            LAST_SYNCED_COMMIT="${hash}"
            break
        fi
    done
}

# display new commits since last sync
output_new_commit_list() {
    if [ -z "${LAST_SYNCED_COMMIT}" ]; then
        write_out -1 "\nNo previous sync found from upstream repo. Syncing entire commit history."
        UNSHALLOW=true
    else
        write_out -1 '\nNew commits since last sync:'
        git log upstream/"${INPUT_UPSTREAM_SYNC_BRANCH}" "${LAST_SYNCED_COMMIT}"..HEAD ${INPUT_GIT_LOG_FORMAT_ARGS}
    fi
}

# sync from upstream to target_sync_branch
sync_new_commits() {
    write_out -1 '\nSyncing new commits...'

    if [ "${UNSHALLOW}" = true ]; then
        git repack -d upstream "${INPUT_UPSTREAM_SYNC_BRANCH}"
        git pull --unshallow --no-edit ${INPUT_UPSTREAM_PULL_ARGS} upstream "${INPUT_UPSTREAM_SYNC_BRANCH}"
    else
        # pull_args examples: "--ff-only", "--tags", "--ff-only --tags"
        git pull --no-edit ${INPUT_UPSTREAM_PULL_ARGS} upstream "${INPUT_UPSTREAM_SYNC_BRANCH}"
    fi

    COMMAND_STATUS=$?

    if [ "${COMMAND_STATUS}" != 0 ]; then
        # exit on commit pull fail
        write_out "${COMMAND_STATUS}" "New commits could not be pulled."
    fi

    write_out "g" 'SUCCESS\n'
}
