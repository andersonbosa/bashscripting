#!/usr/bin/env bash
# author: @andersonbosa <@t4inha>
# purpose
#   facilitar a cópia dos arquivos + comuns de configuração :)
# license: copyleft

function get_usage() {
  echo -e """
   usages:

$ backup_dots git@github.com:andersonbosa/dotfiles.git
$ backup_dots https://github.com/andersonbosa/dotfiles.git
$ backup_dots ~/dots
"""
}

function backup_collection() {
  local default_places_to_backup=(
    ~/.moshell.sh
    ~/.config/terminator
    ~/.i3
    ~/.zsh*
    ~/.*rc
    ~/.SpaceVim*
  )

  # create the backup of backups
  bak_the_bak_folder=".bak/$(date +%y-%m-%d)/"
  mkdir -p $bak_the_bak_folder

  for item in ${default_places_to_backup[@]}; do
    if [ -e "$item" ]; then # if already exists, bak the bak
      cp -rf $item "$bak_the_bak_folder"
    fi

    cp -rf $item . || echo "[❌] $item"
    echo "[✔️] $item"
  done

  unset default_places_to_backup
  return 0
}

function backup_dots() {
  # @param {string} $1

  local dotfiles_path="$1"
  if [[ -z "$dotfiles_path" ]]; then
    get_usage
    return 2
  fi

  if [[ $dotfiles_path =~ git ]]; then
    git clone $dotfiles_path
    cd dotfiles
  else
    cd $dotfiles_path
  fi

  backup_collection

  unset dotfiles_path
  return 0
}

backup_dots $@
