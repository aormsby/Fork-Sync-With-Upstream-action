#!/bin/sh

# source action scripts, then run individual functions

# config git settings
. ../run/config_git.sh
config_for_action

# checkout target branch in source repo
. ../run/checkout_branch.sh
checkout

# set upstream repo
. ../run/set_upstream_repo.sh
set_upstream

# check for new commits and sync or exit
. ../run/get_updates.sh
check_for_updates
output_new_commit_list
sync_new_commits

# push newly sunced commits to local branch
. ../run/push_udpates.sh
push_new_commits

# git config cleanup for workflow continuation
# function from config_git.sh
reset_git_config
