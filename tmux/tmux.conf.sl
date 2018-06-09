# chroma
set -g default-terminal "screen-256color"

# thanks to PCKeyboardHack, F10 is caps lock and caps lock is F10
set-option -g prefix F10

# go to last window by hitting caps lock two times in rapid succession
bind-key F10 last-window

# Don't delay very long on <ESC> so that vim is still usable.
set -sg escape-time 0

# Start window and pane indexes at 1; too hard to reach for 0.
set -g base-index 1
setw -g pane-base-index 1

# use PREFIX | to split window horizontally and PREFIX - to split vertically
bind | split-window -h
bind - split-window -v

# Make the current window the first window
bind T swap-window -t 1

# set window notifications
set-window-option -g automatic-rename off

# status bar config
set -g status-left "#h:[#S]"
set -g status-left-length 50
set -g status-right-length 50

set -g history-limit 100000
#setw -g window-status-current-format "|#I:#W|"
set-window-option -g automatic-rename off

# Activity monitoring
setw -g monitor-activity on
set -g visual-activity on

# force a reload of the config file
unbind r
bind r source-file ~/.tmux.conf

# quick pane cycling
unbind ^A
bind ^A select-pane -t :.+

# pane sizing
bind u resize-pane -U 10
bind d resize-pane -D 10
bind l resize-pane -L 10
bind r resize-pane -R 10

# direnv subshell mangling
set-option -g update-environment "DIRENV_DIFF DIRENV_DIR DIRENV_WATCHES"
set-environment -gu DIRENV_DIFF
set-environment -gu DIRENV_DIR
set-environment -gu DIRENV_WATCHES
set-environment -gu DIRENV_LAYOUT

source-file "${DOTFILES}/tmux/tmux-themepack/powerline/double/cyan.tmuxtheme"
