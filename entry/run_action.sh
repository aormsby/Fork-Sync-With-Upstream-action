#!/bin/sh

# TODO: SPIKE on 'live' tests through the action runner

# TODO: update LOCAL MODE default vars to be a good functional example
# Set custom vars for LOCAL MODE run of action
if [ -z "${GITHUB_ACTIONS}" ] || [ "${GITHUB_ACTIONS}" = false ]; then
    echo "Running action in LOCAL MODE..."

    # TODO: change name to upstream sync if possible on GH
    INPUT_GIT_CONFIG_USER="GH Action - Upstream Sync"
    INPUT_GIT_CONFIG_EMAIL="action@github.com"
    INPUT_GIT_CONFIG_PULL_REBASE=false
    
    # TODO: put all local var options here for manual user set
fi

: '
TODO: determine best method for users to run this locally:
 - place project inside the target repo?
 - add var for path to repo?
 - perform target repo checkout inside this project to perform actions?
'

# TODO: check for required yaml values on start

# config git settings
. ../run/config_git.sh && config_for_action

# reset git settings
. ../run/config_git.sh && reset_after_action

# . ../run/token_access.sh
