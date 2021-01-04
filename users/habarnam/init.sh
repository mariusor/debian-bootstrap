#!/bin/bash

test -z "${_username}" && _username=$(basename "$(dirname "$BASH_SOURCE")")
test -z "${_userid}" && _userid=1199
test -z "${_usergroups}" && _usergroups="sudo"
test -z "${_usershell}" && _usershell="/bin/bash"
test -z "${_userpackages}" && _userpackages="libpam-systemd neovim powerline python-powerline mc bash-completion awscli htop tmux"
test -z "${_userkeys}" && _userkeys=(
 "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIjsLsDQ49ASkbqn0MbsWGF0+D+YPC1FvHIZLejzoFcN"
 "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICmtU4Qj6o6SFPtlm/pBtqjYRadL/2jJgP3UOyp/5WoH"
)

_userhome="/home/${_username}"
###########

