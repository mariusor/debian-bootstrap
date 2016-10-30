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

function install_user_packages {
    export DEBIAN_FRONTEND=noninteractive
    apt-get install -q -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" libpam-systemd neovim powerline python-powerline mc bash-completion awscli htop tmux
}

function install_app_packages {
    export DEBIAN_FRONTEND=noninteractive
    apt-get install -q -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" git nginx php-fpm php-pgsql php-mbstring php-intl composer certbot 

    configure_nginx 
    configure_php-fpm
}

function add_users {
    useradd -m -s /bin/bash -u 54321 -G sudo habarnam
    mkdir -p /home/habarnam/.ssh
    chmod 700 /home/habarnam/.ssh
    echo "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBATB9Su5K2N5EOKSeYHdecIDqYnq0kM3QyCOsSziMn8rDHR1pls5WDTvVl4/fg7W9OsWexg1HVKHXfTXmTOh7hE=" >> /home/habarnam/.ssh/authorized_keys
    echo "ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBAEsd9sZcNWOlzTIX9VTSFbY3V3aGtkEtfPU3XO3C2lDFL5ORQFws85eQ4mtw5TxfBEmYBItSXCBBEKBYgywbCL2AQH1NueikJUV6K8lyQ4qxKU8wW0H5PDXHbELXo2pCDzgADJbN2CKaPaBVpq/2klVW736euwJvy4xWZY9cjsDeRzlcw==" >> /home/habarnam/.ssh/authorized_keys

    chmod 600 /home/habarnam/.ssh/authorized_keys
    chown -R habarnam: /home/habarnam/.ssh

    # dotfiles
    sudo -u habarnam /bin/bash -c "curl -C - -f https://codeload.github.com/mariusor/dotfiles/tar.gz/debian-basic | tar -C /home/habarnam --strip 1 -zxf - "

    install_user_packages
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
# script start

function main {
    update_debian

    install_base_packages

    add_users 

    install_app_packages
}

main 
