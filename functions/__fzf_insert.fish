# Copyright 2022 Mitchell Kember. Subject to the MIT License.

function __fzf_insert --description "Insert a file or directory with fzf"
    set token (commandline -t)
    set parts (string split -n / $token)
    set i -1
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
    set tmp (mktemp)
    set tmp_insert (mktemp)
    set side bottom
    test $COLUMNS -ge 100; and set side right
    set helper_dir (status dirname)/fzf_helpers
    set preview_sh $helper_dir/fzf_preview.sh
    set command_sh $helper_dir/fzf_command.sh
    set files (
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
        commandline -f backward-delete-char
        return
    end
    for file in $files
        set escaped $escaped (string escape -- $file)
    end
    set escaped (string join ' ' $escaped)
    if test $always_insert = 1 -o (commandline) != $token -o (count $files) -gt 1
        commandline -t "$escaped "
    else if test -d $files
        commandline -r "cd $escaped"
        commandline -f execute
    else if test -f $files
        commandline -r "$EDITOR $escaped"
        commandline -f execute
    else
        commandline -t "$escaped "
    end
end
