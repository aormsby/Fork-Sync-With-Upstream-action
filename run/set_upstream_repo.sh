#!/bin/sh

set_upstream() {
    write_out -1 "Setting upstream repo."
    git remote add upstream "${UPSTREAM_REPO_URL}"

    # exit if upstream can't be accessed
    if ! git ls-remote -h "${UPSTREAM_REPO_URL}" --quiet; then
        write_out "$?" "Could not verify upstream repo."
    fi

    write_out "r" "SUCCESS\n"
}

# # LOCAL MODE - handle if 'upstream' repo url is already set to another value
    # CHECK_FOR_UPSTREAM_URL=$(git remote get-url "${UPSTREAM_REPO_URL}")
    # if [ "$?" == 0 ] && [ "${CHECK_FOR_UPSTREAM_URL}" != "${UPSTREAM_REPO_URL}" ]; then
    #     write_out 3 "An 'upstream' url is already set for a different repo. Can't set 'upstream'."
    # else if [ "$?" != 0 ]
    #     git remote add upstream ${UPSTREAM_REPO_URL}
    # fi
