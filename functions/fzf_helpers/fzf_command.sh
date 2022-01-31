#!/bin/bash

# Usage: $0 STATE_FILE COMMAND [ARG ...] 

# This script is used by __fzf_insert.fish. The fzf reload action cannot
# maintain state (e.g. to toggle something), so instead this script stores the
# state in a temporary file.

set -eufo pipefail

state=$1

# We need to wait for fzf to complete before reading $state below.
if [[ "$2" == finish ]]; then
    lines=()
    while read -r line; do
        lines+=("$line")
    done
fi

if [[ "$2" == init ]]; then
    root=${3:-.}  # relative path
    type=$4       # type of search: file, directory, or z
    hidden=0      # 1 means show hidden files
    ignore=0      # 1 means show files ignored by .gitignore etc.
else
    {
        read -r -d: root;
        read -r -d: type;
        read -r -d: hidden;
        read -r -d: ignore;
    } < "$state"
fi

case $2 in
    init) ;;
    file|directory|z) type=$2 ;;
    toggle-hidden) ((hidden ^= 1)) ;;
    toggle-ignore) ((ignore ^= 1)) ;;
    home)
        root=$(python3 -c "
import os.path
print(os.path.relpath(os.path.expanduser('~'), os.getcwd()))")
        ;;
    up)
        case $root in
            .) root=.. ;;
            ..*)
                if [[ "$(basename "$root")" == .. ]]; then
                    root=$root/..
                else
                    root=$(dirname "$root")
                fi
                ;;
            *) root=$(dirname "$root") ;;
        esac
        ;;
    down)
        dir=$root/$3
        if [[ -d "$dir" ]] || dir=$(dirname "$dir") && [[ -d "$dir" ]]; then
            root=$dir
            root=${root#./}
        fi
        ;;
    finish)
        prefix=
        [[ "$root" != . ]] && prefix=$root/
        for line in "${lines[@]+"${lines[@]}"}"; do
            echo "$prefix$line"
        done
        exit
        ;;
    *) echo "$0: $2: invalid command" >&2; exit 1 ;;
esac

echo "$root:$type:$hidden:$ignore:" > "$state"

cd "$root"

# First line for fzf --header-lines=1.
header=$(pwd)
header=${header/#$HOME/\~}
printf "\x1b[33;1m%s\x1b[0m\n" "$header"

if [[ "$type" == z ]]; then
    cwd=$(pwd)
    [[ "$cwd" != / ]] && cwd=$cwd/
    fish -c "z --list '$(pwd)' 2>/dev/null" | awk -v "cwd=$cwd" '{
        if (index($2, cwd) == 1 && $2 != cwd)
            print substr($2, length(cwd) + 1);
    }'
    exit
fi

args=(--type "$type" --type symlink --follow --exclude .git --strip-cwd-prefix)
[[ "$hidden" -eq 1 ]] && args+=(--hidden)
[[ "$ignore" -eq 1 ]] && args+=(--no-ignore)
# Arbitrary limit to avoid listing tons of files under $HOME.
[[ "$HOME" == "$(pwd)"* ]] && args+=(--max-depth 5)

fd "${args[@]}"
