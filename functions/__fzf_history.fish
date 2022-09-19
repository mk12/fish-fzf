# Copyright 2022 Mitchell Kember. Subject to the MIT License.

function __fzf_history --description "Search command history with fzf"
    history merge
    history -z \
        | fzf --read0 --print0 \
        --tiebreak=index \
        --query=(commandline) \
        --preview="echo -- {} | fish_indent --ansi" \
        --preview-window="bottom:3:wrap" \
        | read -lz cmd
    and commandline -- (string trim -r $cmd)
    commandline -f repaint
end
