#!/bin/sh

# TODO: SPIKE on 'live' tests through the action runner

# TODO: set -e??

# TODO: update LOCAL MODE default vars to be a good functional example
# Set custom vars for LOCAL MODE run of action
if [ -z "${GITHUB_ACTIONS}" ] || [ "${GITHUB_ACTIONS}" = false ]; then
    echo "Running action in LOCAL MODE..."

    # The Github login of the user initiating the workflow run
    GITHUB_ACTOR='aormsby'GITHUB_ACTOR='aormsby'
    INPUT_UPSTREAM_REPOSITORY="aormsby/Fork-Sync-With-Upstream-action"

    # Token to authenticate access to your repository /
    # reading from external file to prevent pushing to remote repository
    INPUT_GITHUB_TOKEN=$(cat ../test_key.txt)

    # TODO: change name to upstream sync if possible on GH
    INPUT_GIT_CONFIG_USER="GH Action - Upstream Sync"
    INPUT_GIT_CONFIG_EMAIL="action@github.com"
    INPUT_GIT_CONFIG_PULL_REBASE=false

    INPUT_GIT_CHECKOUT_ARGS=""
    INPUT_TARGET_BRANCH="main"

    INPUT_UPSTREAM_BRANCH="main"
    INPUT_GIT_FETCH_ARGS=""
    INPUT_GIT_LOG_FORMAT_ARGS=""

    INPUT_GIT_PULL_ARGS=""
    
    # TODO: put all local var options here for manual user set
fi

: '
TODO: determine best method for users to run this locally:
 - place project inside the target repo?
 - add var for path to repo?
 - perform target repo checkout inside this project to perform actions?
'

# check for required action input
. ../run/check_action_inputs.sh && check_inputs

# config git settings
. ../run/config_git.sh && config_for_action

# checkout target branch in source repo
. ../run/checkout_branch.sh && checkout

# set upstream repo
. ../run/set_upstream_repo.sh && set_upstream

# check for new commits and sync or exit
. ../run/get_updates.sh && check_for_updates
. ../run/get_updates.sh && echo_new_commit_list
. ../run/get_updates.sh && sync_new_commits

# push newly sunced commits to local branch
. ../run/push_udpates.sh && push_new_commits

# reset git settings
. ../run/config_git.sh && reset_after_action
