#!/usr/bin/env bash

# Add an "alert" alias for long running commands.  Use like so: ~$ sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
# listing files
alias l="ls -lahv"
alias t="tree -L 1"
alias tt="tree -L 2"

# network
alias restart-dns='sudo killall -HUP mDNSResponder'
alias hosts="sudo vim /etc/hosts"

function termbin() {
  # for further information see https://termbin.com
  while [ "$#" -gt 0 ]; do
    case $1 in
    -h | --help)
      echo """\
  $(basename $0)@1.0.0 

    usage:

\$ termbin --upload /tmp/script.sh
\$ termbin --download v7gdsd2
"""
      shift
      ;;

    -u | --upload)
      filepath_to_upload="$2"
      termbin_link="$(cat $filepath_to_upload | netcat termbin.com 9999 | -)"
      echo "🔗  $termbin_link"
      return 0
      ;;

    -d | --download)
      echo "List the options"
      curl "https://termbin.com/$2"
      shift
      ;;

    -e | --encode)
      # todo
      shift
      ;;

    *)
      echo "unknow option"
      shift
      ;;
    esac
  done
}
alias tb="termbin"
alias tbu="nc termbin.com 9999"

function tei() {
  # start to write your powerfull script instantly after
  # open your prefered terminal editor
  #	default path: /tmp
  # default editor: vi
  # @param {string} $1

  if [[ -z "$EDITOR" ]]; then
    export EDITOR="$(which vi)"
  fi

  local TEI_FILENAME=$(mktemp /tmp/teiXXXXXX)
  chmod +x $TEI_FILENAME
  $EDITOR $TEI_FILENAME
  echo "☘️ you'd tei this $TEI_FILENAME"
  unset TEI_FILENAME
}

function ssh-key-permissions() {
  # fix permissions on ssh dir.
  # @param {string} $1 [default="$HOME/.ssh"]
  local SSHPath="$1"
  if [[ -z "$SSHPath" ]]; then # if string empty
    SSHPath="$HOME/.ssh"
  fi
  sudo chown -R "$USER:$USER" "$HOME/.ssh"
  chmod -R 700 "$HOME/.ssh/"
  chmod 600 $HOME/.ssh/*
  chmod 644 $HOME/.ssh/*.pub
  unset SSHPath
}

function gcommit() {
  # update current branch with pull
  # and commit
  # and pull to branch remote ref.
  # @param {string} $1

  local commit_message="$1"
  if [[ -z "$commit_message" ]]; then # if string empty
    commit_message="gcommit:$(date)"
  fi

  local current_branch="$(git branch --show-current)"

  git pull origin $current_branch &&
    git add . &&
    git commit -m "$commit_message" &&
    git push origin $current_branch &&
    echo '✅ done'

  unset commit_message current_branch
}

function rm-apt-repository() {
  # @param {string} $1
  local REPO="$1"
  sudo add-apt-repository --remove "$REPO"
  unset REPO
}

function get-port-connections() {
  # @param {string} $1
  sudo netstat -nlp | grep "$1"
}

function find-here() {
  # @param {string} $1
  find . -name "$1"
}
