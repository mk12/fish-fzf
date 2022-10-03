# Copyright 2022 Mitchell Kember. Subject to the MIT License.

if not status is-interactive
    exit
end

# Workaround for:
# https://github.com/fish-shell/fish-shell/issues/6942#issuecomment-984737309
function __fzf_try_disable_focus
    functions -q __fish_disable_focus && __fish_disable_focus
end

bind \co __fzf_try_disable_focus "__fzf_insert file"
bind \cq __fzf_try_disable_focus "__fzf_insert directory"
bind \ez __fzf_try_disable_focus "__fzf_insert z"
bind \cr __fzf_try_disable_focus "__fzf_history"
