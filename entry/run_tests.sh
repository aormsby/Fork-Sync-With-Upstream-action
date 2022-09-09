#!/bin/sh

# source test scripts, then run individual functions

# shellcheck disable=SC1091
. "${ACTION_PARENT_DIR}"/test/verify_branches.sh
test_target_branch_exists
test_upstream_repo_exists
test_upstream_branch_exists

# shellcheck disable=SC1091
. "${ACTION_PARENT_DIR}"/test/verify_upstream_access.sh
test_has_upstream_repo_access
cleanup_test_dir

# shellcheck disable=SC1091
. "${ACTION_PARENT_DIR}"/test/verify_git_config.sh
test_config_git
