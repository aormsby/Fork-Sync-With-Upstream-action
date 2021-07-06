#!/bin/sh

# check latest commit hashes for a match, exit if nothing to sync

check_for_updates() {
    write_out -1 "Checking for new commits on upstream branch."

    # get latest commit hashes from local and remote branches for comparison
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
        exit_error
    fi
}

exit_no_commits() {
    write_out -1 'No new commits to sync, exiting gracefully.\n' 1>&1
    # TODO: set up way to reset git config at any exit (or point of failure)
    # reset_git
    exit 0
}

exit_error() {
    write_out "r" 'There was an error checking for new commits - please check your inputs. Exiting gracefully.\n' 1>&1
    # TODO: set up way to reset git config at any exit (or point of failure)
    # reset_git
    exit 1
}

# display new commits since last sync
output_new_commit_list() {
    write_out -1 'New commits since last sync:' 1>&1
    git log upstream/"${INPUT_UPSTREAM_BRANCH}" "${LOCAL_COMMIT_HASH}"..HEAD ${INPUT_GIT_LOG_FORMAT_ARGS}
}

# sync from upstream to target_branch
sync_new_commits() {
    write_out -1 'Syncing new commits...' 1>&1
    # pull_args examples: "--ff-only", "--tags"
    # TODO: handle fail better along with all other fails
    git pull --no-edit ${INPUT_GIT_PULL_ARGS} upstream "${INPUT_UPSTREAM_BRANCH}" || exit 1
    write_out "g" 'SUCCESS\n' 1>&1
}
