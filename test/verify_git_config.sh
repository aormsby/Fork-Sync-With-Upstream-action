#!/bin/sh

test_config_git() {
    get_current_user_config
    set_git_config "${INPUT_GIT_CONFIG_USER}" "${INPUT_GIT_CONFIG_EMAIL}" "${INPUT_GIT_CONFIG_PULL_REBASE}"

    verify_set_config
    reset_git_config
    verify_reset_config
}

# store current user config data for reset after action run
get_current_user_config() {
    CURRENT_USER=$(git config --get --default="null" user.name)
    CURRENT_EMAIL=$(git config --get --default="null" user.email)
    CURRENT_PULL_CONFIG=$(git config --get --default="false" pull.rebase)
}

# set action config values
set_git_config() {
    git config user.name "${1}"
    git config user.email "${2}"
    git config pull.rebase "${3}"
}

# verify test values have been set
verify_set_config() {
    write_out "y" "TEST"
    write_out -1 "[Config User Name] -> user.name should equal '${INPUT_GIT_CONFIG_USER}'"
    TEST_NAME_RESULT=$(git config --get user.name)

    if [ "${TEST_NAME_RESULT}" = "${INPUT_GIT_CONFIG_USER}" ]; then
        write_out "g" "PASSED\n"
    else
        write_out "r" "FAILED - user.name is '${TEST_NAME_RESULT}'\n"
    fi

    write_out "y" "TEST"
    write_out -1 "[Config User Email] -> user.email should equal '${INPUT_GIT_CONFIG_EMAIL}'"
    TEST_EMAIL_RESULT=$(git config --get user.email)

    if [ "${TEST_EMAIL_RESULT}" = "${INPUT_GIT_CONFIG_EMAIL}" ]; then
        write_out "g" "PASSED\n"
    else
        write_out "r" "FAILED - user.email is '${TEST_EMAIL_RESULT}'\n"
    fi

    write_out "y" "TEST"
    write_out -1 "[Config Pull Settings] -> pull.rebase should equal '${INPUT_GIT_CONFIG_PULL_REBASE}'"
    TEST_PULL_CONFIG_RESULT=$(git config --get pull.rebase)

    if [ "${TEST_PULL_CONFIG_RESULT}" = "${INPUT_GIT_CONFIG_PULL_REBASE}" ]; then
        write_out "g" "PASSED"     # no \n because of cleanup output
    else
        write_out "r" "FAILED - pull.rebase is '${TEST_PULL_CONFIG_RESULT}'\n"
    fi
}

# reset to original user config values
reset_git_config() {
    # unset user if value was previously null, else reset
    if [ "${CURRENT_USER}" = "null" ]; then
        git config --unset user.name
        CURRENT_USER=""
    else
        git config user.name "${CURRENT_USER}"
    fi

    # unset email if value was previously null, else reset
    if [ "${CURRENT_EMAIL}" = "null" ]; then
        git config --unset user.email
        CURRENT_EMAIL=""
    else
        git config user.email "${CURRENT_EMAIL}"
    fi

    # always reset pull.rebase
    git config pull.rebase "${CURRENT_PULL_CONFIG}"
}

# verify original values
verify_reset_config() {
    RESET_USER=$(git config --get user.name)
    RESET_EMAIL=$(git config --get user.email)
    RESET_PULL_CONFIG=$(git config --get pull.rebase)

    if [ "${RESET_USER}" = "${CURRENT_USER}" ] &&
        [ "${RESET_EMAIL}" = "${CURRENT_EMAIL}" ] &&
        [ "${RESET_PULL_CONFIG}" = "${CURRENT_PULL_CONFIG}" ]; then
        write_out -1 "(All git configs set back to original user values.)\n"
    else
        write_out "r" "(Config reset failed. Please check your local git config).\n"
    fi
}
