#!/bin/bash
test -z "${_userprofiletar}" && _userprofiletar="https://codeload.github.com/mariusor/dotfiles/tar.gz/debian-basic"

# dotfiles
sudo -u "${_username}" /bin/bash -c "curl -C - -f \"${_userprofiletar}\" | tar -C \"${_userhome}\" --strip 1 -zxf - "
