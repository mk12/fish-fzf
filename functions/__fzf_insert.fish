# Copyright 2022 Mitchell Kember. Subject to the MIT License.

function __fzf_insert --description "Insert a file or directory with fzf"
    set -l token (commandline -t)
    set token (string replace -r '^~' $HOME $token)
    set token (string replace -r --all '/+' "/" $token)
    set token (string replace -r '/$' "" $token)
    set -l parts (string split / $token)
    set -l i -1
    set -l root
    set -l query
    while true
        set root (string unescape (string join / $parts[..$i]))
        if test -d "$root" -o -z "$root"
            if test -n "$root"
                set -e parts[..$i]
            end
            set query (string unescape (string join / $parts))
            break
        end
        set i (math $i - 1)
    end
    set -l tmp (mktemp)
    set -l tmp_insert (mktemp)
    set -l side bottom
    test $COLUMNS -ge 100; and set side right
    set -l helper_dir (status dirname)/fzf_helpers
    set -l preview_sh $helper_dir/fzf_preview.sh
    set -l command_sh $helper_dir/fzf_command.sh
    set -l files (
        $command_sh $tmp init "$root" $argv \
        | fzf --query=$query --multi --keep-right --header-lines=1 \
        --preview="'$preview_sh' {} '$tmp'" \
        --preview-window=$side \
        --bind="ctrl-o:reload('$command_sh' '$tmp' file)" \
        --bind="ctrl-q:reload('$command_sh' '$tmp' directory)" \
        --bind="alt-z:reload('$command_sh' '$tmp' z)" \
        --bind="alt-.:reload('$command_sh' '$tmp' toggle-hidden)" \
        --bind="alt-i:reload('$command_sh' '$tmp' toggle-ignore)" \
        --bind="alt-h:reload('$command_sh' '$tmp' home)+clear-query" \
        --bind="alt-up:reload('$command_sh' '$tmp' up)+clear-query" \
        --bind="alt-down:reload('$command_sh' '$tmp' down {})+clear-query" \
        --bind="alt-enter:execute-silent(rm '$tmp_insert')+accept" \
        | $command_sh $tmp finish
    )
    test -e $tmp_insert; set always_insert $status
    rm -f $tmp $tmp_insert
    set files (string split -n \n $files)
    # Workaround for https://github.com/fish-shell/fish-shell/issues/5945
    printf "\x1b[A"
    if test (count $files) -eq 0
        commandline -i " "
        commandline -f backward-delete-char repaint
        return
    end
    set -l escaped
    for file in $files
        set -a escaped (string escape -- $file)
        if string match -q -r "$HOME/*" $escaped
            set -l n (string length "$HOME/*")
            set escaped "~/$(string sub -s $n $escaped)"
        end
    end
    set escaped (string join ' ' $escaped)
    if test $always_insert = 1 -o (commandline) != $token -o (count $files) -gt 1
        commandline -t "$escaped "
        commandline -f repaint
    else if test -d $files
        commandline -r "cd $escaped"
        commandline -f repaint execute
    else if test -f $files
        commandline -r "$EDITOR $escaped"
        commandline -f repaint execute
    else
        commandline -t "$escaped "
        commandline -f repaint
    end
end
