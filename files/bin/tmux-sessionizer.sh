#!/usr/bin/env bash

selected=$(zoxide query -i)
if [[ -z "$selected" ]]; then
    exit 0
fi
session_name=$(basename "$selected" | tr . _)

if ! tmux list-sessions | grep -q "^$session_name:"; then
    tmux new-session -ds "$session_name" -c "$selected"
    tmux kill-session -t "0" && tmux kill-window -t "0"
fi
tmux new-window -t "$session_name":1 -c "$selected"
tmux send-keys -t "$session_name":1 'opencode .' Enter
tmux new-window -t "$session_name":2 -c "$selected"

if [[ -z $TMUX ]]; then
    tmux attach-session -t "$session_name"
else
    tmux switch-client -t "$session_name"
fi
