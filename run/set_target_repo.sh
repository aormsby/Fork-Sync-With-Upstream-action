#!/bin/sh

set_target() {
    write_out -1 "Setting target repo to '${INPUT_TARGET_SYNC_REPO}'."
    git remote add origin "${TARGET_REPO_URL}"

    # # exit if target can't be accessed
    # if ! git ls-remote -h "${TARGET_REPO_URL}" --quiet; then
    #     write_out "$?" "Could not verify target repo."
    # fi

    write_out "g" "SUCCESS\n"
}
