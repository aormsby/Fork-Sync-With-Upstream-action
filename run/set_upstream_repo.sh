#!/bin/sh

set_upstream() {
    write_out -1 "Setting upstream repo."
    # TODO: handle error better with full message
    git remote add upstream ${UPSTREAM_REPO_URL} || exit 1
    write_out "r" "SUCCESS\n"
}
