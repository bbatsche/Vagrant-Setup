codeup-ansible-command() {
    local ANSIBLE_HOST=$1
    shift

    local ANSIBLE_SCRIPT=$1
    shift

    ansible-playbook -i $HOME/vagrant-lamp/ansible/hosts -l $ANSIBLE_HOST $HOME/vagrant-lamp/ansible/$ANSIBLE_SCRIPT $@
}

vagrant-create-site() {
    if [[ $# -eq 0 ]]; then
        echo -ne "Usage: "
        echo "vagrant-create-site <domain-name.dev> [--append-hosts]"
        echo
        echo "    <domain-name.dev> : Local development domain name"
        echo "    [--append-host]   : Add record to /etc/hosts file for this site"
        echo "                        (optional, will ask for sudo password)"
        return
    fi

    local DOMAIN=$1
    shift

    local APPEND_HOST=0
    local ARGS=("$@")

    for (( i = 0; i < ${#ARGS[@]}; i++ )); do
        if [[ ${ARGS[$i]} == "--append-host" ]]; then
            local APPEND_HOST=1
            unset ARGS[$i]
        fi
    done

    if [[ $APPEND_HOST -eq 1 ]]; then
        sudo codeup-ansible-command vagrant site-create.yml -e "domain=$DOMAIN" -e "append_host=true"
    else
        codeup-ansible-command vagrant site-create.yml -e "domain=$DOMAIN"
    fi
}

prod-create-site() {
    if [[ $# -eq 0 ]]; then
        echo -ne "Usage: "
        echo "prod-create-site <domain-name.com>"
        echo
        echo "    <domain-name.com> : Production domain name"
        return
    fi

    local DOMAIN=$1
    shift

    codeup-ansible-command production site-create.yml -e "domain=$DOMAIN" --ask-sudo-pass
}

vagrant-create-mysql-admin() {
    codeup-ansible-command vagrant mysql-user-db.yml -e "mysql_admin=true"
}
prod-create-mysql-admin() {
    codeup-ansible-command production mysql-user-db.yml -e "mysql_admin=true"
}

vagrant-create-mysql-db() {
    if [[ $# -eq 0 ]]; then
        echo -ne "Usage: "
        echo "vagrant-create-mysql-db <db_name>"
        echo
        echo "    <db_name> : Local development database name"
        return
    fi

    local DB_NAME=$1
    shift

    codeup-ansible-command vagrant mysql-user-db.yml -e "db_name=$DB_NAME"
}

prod-create-mysql-db() {
    if [[ $# -eq 0 ]]; then
        echo -ne "Usage: "
        echo "prod-create-mysql-db <db_name>"
        echo
        echo "    <db_name> : Production database name"
        return
    fi

    local DB_NAME=$1
    shift

    codeup-ansible-command production mysql-user-db.yml -e "db_name=$DB_NAME"
}

alias ll='ls -GFlh'
alias la='ls -GFAlh'
