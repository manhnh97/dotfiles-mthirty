#!/bin/bash

#################################
# Author:       manhnh97
# Description:  script which sets aliases and functions so they can be used in the terminal
#               some variables depend on ~/.script/env.sh 
#################################

# Easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~"
alias work="cd /workspaces"
alias -- -="cd -"
alias cd='cd -P' # autofollow symlinks
function cs() { cd $1;ls -1 --color=auto; } # cd + ls
alias ka='killall'

# f = show dir ending "/", symlinks "*"...
alias l="ls -lF --group-directories-first" # List all files
alias la="ls -laF  --group-directories-first" # List all files excluding . and ..
alias lt="ls -lt " # List all files excluding . and ..
alias lsd="ls -lF | grep --color=never '^d'" # List only directories
alias lsf="ls -p | grep -v /"

# Add an "alert" alias for long running commands. Use like so: sleep 10; alert
alias alert="notify-send"

