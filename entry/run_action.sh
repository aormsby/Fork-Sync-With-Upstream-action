#!/bin/sh

# source action scripts, then run individual functions

# shellcheck disable=SC1091
# config git settings
. "${ACTION_PARENT_DIR}"/run/config_git.sh
config_for_action

# shellcheck disable=SC1091
# checkout target branch in target repo
. "${ACTION_PARENT_DIR}"/run/checkout_branch.sh
checkout

# shellcheck disable=SC1091
# set upstream repo
. "${ACTION_PARENT_DIR}"/run/set_upstream_repo.sh
set_upstream

# shellcheck disable=SC1091
# check for new commits and sync or exit
. "${ACTION_PARENT_DIR}"/run/get_updates.sh
check_for_updates
output_new_commit_list
sync_new_commits

# shellcheck disable=SC1091
# push newly synced commits to local branch
. "${ACTION_PARENT_DIR}"/run/push_updates.sh
push_new_commits

# git config cleanup for workflow continuation
# function from config_git.sh
reset_git_config
