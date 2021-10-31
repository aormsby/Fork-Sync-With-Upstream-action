#!/bin/sh

# shellcheck disable=SC1091
# source action scripts, then run individual functions

# config git settings
. "${ACTION_PARENT_DIR}"/run/config_git.sh
config_for_action

# checkout target branch in target repo
. "${ACTION_PARENT_DIR}"/run/checkout_branch.sh
checkout

# set upstream repo
. "${ACTION_PARENT_DIR}"/run/set_upstream_repo.sh
set_upstream

# check for new commits and sync or exit
. "${ACTION_PARENT_DIR}"/run/get_updates.sh
check_for_updates
find_last_synced_commit
output_new_commit_list
sync_new_commits

# push newly synced commits to local branch
. "${ACTION_PARENT_DIR}"/run/push_updates.sh
push_new_commits

# git config cleanup for workflow continuation
# function from config_git.sh
reset_git_config
