#!/bin/sh

# source test scripts, then run individual functions
. ../test/verify_branches.sh
test_target_branch_exists
test_upstream_repo_exists
test_upstream_branch_exists

. ../test/verify_upstream_access.sh
test_has_upstream_repo_access
cleanup_test_dir

. ../test/verify_git_config.sh
test_config_git
