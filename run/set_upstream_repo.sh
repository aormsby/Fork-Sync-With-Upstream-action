#!/bin/sh

set_upstream() {
    echo "Setting upstream repo."
    # TODO: handle error better with full message
    git remote add upstream ${UPSTREAM_REPO_URL} || exit 1
    echo "SUCCESS\n"
}
