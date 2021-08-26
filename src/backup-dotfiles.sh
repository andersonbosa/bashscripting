#!/usr/bin/env bash
# author: https://github.com/andersonbosa <aka @t4inha>
# purpose
#   to make easy backup common files :)
#
# license: https://unlicense.org/
###################################################################

function get_usage() {
  echo -e """
   usages:

$ dots git@github.com:andersonbosa/dotfiles.git
$ dots https://github.com/andersonbosa/dotfiles.git
$ dots ~/dots
"""
}

function log-backup-timestamp() {
  echo "$(date +%d-%m-%y-%Hh%Mm%Ss)" >last_run.log
  touch last_run.log
  #git rm -r --cached .bak/ &>/dev/null
}

function backup_collection_path() {
  # ! what will be put in the backup
  local DEFAULT_PLACES_TO_BACKUP=(
    ~/.moshell.sh
    ~/.config/terminator
    ~/.i3
    ~/.zsh*
    ~/.*rc
    ~/.SpaceVim*
    ~/.config/surfraw
    ~/.config/wireshark
    ~/.vimrc
  )

  for item in "${DEFAULT_PLACES_TO_BACKUP[@]}"; do
    if [ -e "$item" ]; then
      cp -rf $item . || echo "[x] $item"
      echo "[✔️] $item"
    fi

  done

  # after backup been done:
  log-backup-timestamp
  return 0
}

function send_to_github() {
  local git_msg=$1
  if [[ -z "$git_msg" ]]; then
    git_msg="auto-backup"
  fi

  git add --all .
  git commit --all -m "$git_msg"
  git status
  echo '[[  press ENTER to continue  OR  CTRL+C to cancel  ]]'
  read -- 
  git push
}

# script entrypoint
function dots() {
  # @param {string} $1 dotfiles_path
  # @param {string} $2 commit_message
  echo '''# backuping the dots... '''

  local dotfiles_path="$1"
  local commit_message="$2"

  if [[ -z "$dotfiles_path" ]]; then
    get_usage
    return 2
  fi

  if [[ $dotfiles_path =~ git ]]; then
    # if $1 is git repo do
    git clone $dotfiles_path dotfiles
    cd dotfiles
  else
    cd $dotfiles_path
  fi

  backup_collection_path
  send_to_github "$commit_message"

  unset dotfiles_path commit_message
  return 0
}
dots $@
