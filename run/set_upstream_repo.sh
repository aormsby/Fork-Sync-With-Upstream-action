#!/bin/sh

set_upstream() {
    write_out -1 "Setting upstream repo."
    git remote add upstream ${UPSTREAM_REPO_URL}

    # exit if upstream can't be accessed
    git ls-remote -h ${UPSTREAM_REPO_URL} --quiet
    if [ "$?" != 0 ]; then
        write_out "$?" "Could not verify upstream repo."
    fi

    write_out "r" "SUCCESS\n"
}
