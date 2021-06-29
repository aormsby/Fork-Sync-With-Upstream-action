#!/bin/sh

set_upstream() {
    # TODO: handle error better with full message
    git remote add upstream ${UPSTREAM_REPO_URL} || exit 1
}
