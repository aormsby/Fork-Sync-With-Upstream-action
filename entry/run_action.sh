#!/bin/sh

# TODO: SPIKE on running 'live' tests through the action runner

# TODO: update local mode vars to be a good functional example
# Set custom vars for LOCAL MODE run of action
if [ -z "${GITHUB_ACTIONS}" ] || [ "${GITHUB_ACTIONS}" = false ]; then
    echo "Running action in LOCAL MODE..."
    INPUT_GITHUB_TOKEN="$(cat ../test_key.txt)"
fi

: '
TODO: determine how to actually run this locally:
 - place project inside the target repo?
 - add var for path to repo?
 - perform target repo checkout inside this project to perform actions?
'

# . ../run/token_access.sh
