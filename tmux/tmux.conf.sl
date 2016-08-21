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

# reload ~/.tmux.conf using PREFIX r
bind r source-file ~/.tmux.conf \; display "Reloaded!"

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
#set -g status-right "⚡ #(~/.tmux/plugins/tmux-battery) %H:%M %d-%h-%Y"
#setw -g window-status-current-format "|#I:#W|"
set-window-option -g automatic-rename off

set -g status-right " #{battery_icon} #{battery_percentage} [#{battery_remain}] | %a  %H:%M %d-%h-%Y"

# highlight active window
set-window-option -g window-status-current-bg colour238
set-window-option -g window-status-current-fg colour81
set-window-option -g window-status-current-attr bold
set-window-option -g window-status-current-format ' [#I] #W '

# Activity monitoring
setw -g monitor-activity on
set -g visual-activity on
