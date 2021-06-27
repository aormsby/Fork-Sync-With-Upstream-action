#!/bin/sh

set_upstream() {
    # TODO: handle error better with full message
   git remote add upstream ${UPSTREAM_REPO_URL} || exit 1
}

# cleanup changes after local tests
unset_upstream() {
    git remote remove upstream
}

run_tests() {
    # Nothing to verify here,
    # Simply set upstream repo for later tests
    set_upstream
    # TODO: if future tests are not feasible, perhaps remove this
}
