#!/bin/bash

test -z "${_username}" && _username=$(basename "$(dirname "$BASH_SOURCE")")
test -z "${_userid}" && _userid=1199
test -z "${_usergroups}" && _usergroups="sudo"
test -z "${_usershell}" && _usershell="/bin/bash"
test -z "${_userpackages}" && _userpackages="libpam-systemd neovim powerline python-powerline mc bash-completion awscli htop tmux"
test -z "${_userkeys}" && _userkeys=(
 "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBATB9Su5K2N5EOKSeYHdecIDqYnq0kM3QyCOsSziMn8rDHR1pls5WDTvVl4/fg7W9OsWexg1HVKHXfTXmTOh7hE="
 "ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBAEsd9sZcNWOlzTIX9VTSFbY3V3aGtkEtfPU3XO3C2lDFL5ORQFws85eQ4mtw5TxfBEmYBItSXCBBEKBYgywbCL2AQH1NueikJUV6K8lyQ4qxKU8wW0H5PDXHbELXo2pCDzgADJbN2CKaPaBVpq/2klVW736euwJvy4xWZY9cjsDeRzlcw==")

_userhome="/home/${_username}"
########### 

