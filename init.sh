#!/bin/bash

function update_debian {
    configure_apt 
    export DEBIAN_FRONTEND=noninteractive 
    apt-get update -q
    apt-get upgrade

}

function configure_apt {
    echo 'APT::Install-Recommends "false";' >> /etc/apt/apt.conf.d/99no-recommended-or-optional
    echo 'APT::Install-Suggests "false";' >> /etc/apt/apt.conf.d/99no-recommended-or-optional
}

function install_base_packages {

    export DEBIAN_FRONTEND=noninteractive
    apt-get install -q -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" openssh-server sudo gnupg curl man less

    configure_sudo
}


function install_app_packages {
    export DEBIAN_FRONTEND=noninteractive
    apt-get install -q -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" git nginx php-fpm php-pgsql php-mbstring php-intl composer certbot 

    configure_nginx 
    configure_php-fpm
}

function add_users {
    test -d "users" || { echo "No users."; exit 1; }

    for _username in $( ls "users" ); do
        _userinitscript="users/${_username}/init.sh"
		_userprofilescript="users/${_username}/profile.sh"
        test -f "${_userinitscript}" || { echo "No user init script for '${_username}'."; continue; }

        source "${_userinitscript}" 

		add_user 
    done
}

function add_user {
	create_user
	install_user_packages
	install_user_profile
	configure_ssh
}

function install_user_profile {
	test -f "${_userprofilescript}" && source "${_userprofilescript}"
}

function create_user {
    useradd -m -s "${_usershell}" -u "${_userid}" -G "${_usergroups}" "${_username}"
}

function configure_ssh {
    _sshdir="${_userhome}/.ssh"
    test -d "${_sshdir}" || sudo -u ${_username} mkdir -m 700 -p "${_sshdir}"

    for _sshkey in $_userkeys; do
        echo "${_sshkey}" >> "${_sshdir}/authorized_keys"
    done

    chmod 600 "${_sshdir}/authorized_keys"
    chown -R ${_username}: "${_sshdir}"
}

function install_user_packages {
    export DEBIAN_FRONTEND=noninteractive
    apt-get install -q -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" "${_userpackages}"
}

function configure_sudo {
    echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/99-sudo-no-pass
    chmod 0440 /etc/sudoers.d/99-sudo-no-pass
    # remove if fails visudo check
    /usr/sbin/visudo -c || rm /etc/sudoers.d/99-sudo-no-pass
}

function configure_nginx {
    echo "error_log syslog:server=unix:/dev/log;" >> /etc/nginx/conf.d/99-log-to-journal.conf
    echo "access_log syslog:server=unix:/dev/log;" >> /etc/nginx/conf.d/99-log-to-journal.conf
}

function configure_php-fpm {
    echo "error_log = syslog" >> /etc/php/7.0/fpm/conf.d/99-log-to-syslog.ini
}

function main {
    update_debian

    install_base_packages

    add_users 

    install_app_packages
}

# script start
main 
