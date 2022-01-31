#!/bin/bash

# Usage: $0 FILE_OR_DIRECTORY [STATE_FILE]

# This script is used by __fzf_insert.fish. It works as a general preview tool
# for any file or directory.

set -eufo pipefail

x=$1

if [[ $# -ge 2 ]]; then
    read -r -d: root < "$2"
    [[ "$root" != . ]] && x=$root/$x
fi

if [[ -f "$x" ]]; then
    if command -v bat &> /dev/null; then
        bat --plain --color=always -- "$x"
    else
        cat -- "$x"
    fi
elif [[ -d "$x" ]]; then
    if command -v exa &> /dev/null; then
        exa -a --color=always -- "$x"
    else
        ls -a --color=always -- "$x"
    fi
fi
