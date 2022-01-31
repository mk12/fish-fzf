# Copyright 2022 Mitchell Kember. Subject to the MIT License.

if not status is-interactive
    exit
end

bind \co "__fzf_insert file"
bind \cq "__fzf_insert directory"
bind \ez "__fzf_insert z"
bind \cr "__fzf_history"
