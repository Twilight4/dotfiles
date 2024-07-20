#!/usr/bin/env bash

# e - script stops on error (return != 0)
# u - error if undefined variable
# o pipefail - script fails if one of piped command fails
# x - output each line (debug)
set -uo pipefail

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

function output-help() {
    echo -e "${BLUE}Usage: $0 [options] [--]

Options:
  -h, -help       Display this message
  -v, -version    Display script version
  -d, -dry-run    Run rsync with --dry-run for test
  -x, -delete     Run rsync with --delete for mirroring
  -s, -size-only  Run rsync with --size-only (no comparison with timestamps)${NC}"
}

function run() {
    local rsync_opts=(-avz)

    __ScriptVersion="1.0"

    while getopts ":hvdxs" opt
    do
    case $opt in

        h|help     )  output-help; exit 0   ;;

        v|version  )  echo -e "${BLUE}$0 -- Version $__ScriptVersion${NC}"; exit 0   ;;

        d|dry-run  )  rsync_opts+=(--dry-run); ;;

        x|delete   )  rsync_opts+=(--delete); ;;

        s|size-only)  rsync_opts+=(--size-only); ;;

        * )  echo -e "${RED}\n  Option does not exist: $OPTARG\n${NC}"
            output-help; exit 1   ;;

    esac
    done
    shift $((OPTIND-1))

    [ "$#" == 0 ] && echo -e "${RED}You need to give a file as the last argument${NC}" && exit 1

    local file="${!#}"
    while read -r line ; do
        src="$(eval echo -e "${line%,*}")"
        dest="$(eval echo -e "${line#*,}")"

        echo -e "${YELLOW}Copying $src to $dest from file $file${NC}"
        
        if [ -d "$src" ]; then
            rsync "${rsync_opts[@]}" "${src}/" "$dest" 2> /tmp/errors
        elif [ -f "$src" ]; then
            rsync "${rsync_opts[@]}" "$src" "$dest" 2> /tmp/errors
        else
            echo -e "${RED}The source $src does not exist -- NO BACKUP CREATED${NC}" && continue
        fi
    done < "$file"

    echo -e "${RED}ERRORS: ${NC}"
    cat /tmp/errors
}

run "$@"
