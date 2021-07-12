#!/bin/sh

# output colors
RED="\033[91m"
YELLOW="\033[93m"
GREEN="\033[32m"
BLUE="\033[96m"
BOLD="\033[1m"
NORMAL="\033[m"

# $1 = color OR exit code
# $2 = message
# Set color and output message, exit gracefully if required
write_out() {
    case $1 in
    # default message, normal output
    -1)
        echo "$2" 1>&1
        ;;

    # red output
    [Rr])
        echo "${BOLD}${RED}$2${NORMAL}" 1>&1
        ;;

    # yellow output
    [Yy])
        echo "${BOLD}${YELLOW}$2${NORMAL}" 1>&1
        ;;

    # green output
    [Gg])
        echo "${BOLD}${GREEN}$2${NORMAL}" 1>&1
        ;;

    # green output
    [Bb])
        echo "${BOLD}${BLUE}$2${NORMAL}" 1>&1
        ;;

    # safe exit, green output
    0)
        echo "${BOLD}${GREEN}SAFE EXIT${NORMAL}" 1>&1
        printf '%s\n' "$2" 1>&1

        early_exit_cleanup
        exit 0
        ;;

    # exit on error, red output
    *)
        echo "${BOLD}${RED}ERROR: ${NORMAL} exit $1" 1>&2
        printf '%s\n' "$2" 1>&2
        echo "Try running in test mode to verify your action input. If that does not help, please open an issue." 1>&2

        early_exit_cleanup
        exit "$1"
        ;;
    esac
}

early_exit_cleanup() {
    reset_git_config
    # TODO: set action fail output var here?
}
