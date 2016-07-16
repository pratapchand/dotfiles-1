#!/bin/sh

#shared variables between install.sh and revert.sh
HOME_DIR=$HOME #makes it easy to test
BACKUP_ROOT="$HOME_DIR/.dotbackup"
SYMLINK_EXT="sl" #extension of files to symlink
BACKUP="$HOME_DIR/.backup"
USER_FOLDER=("$BACKUP/vim" "$HOME_DIR/dev")
