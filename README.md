# Codeup Vagrant Box & Ansible Scripts

This repository contains files and scripts intended for [Codeup](http://www.codeup.com) students to use throughout their class. It contains:

1. A Vagrantfile definition for local development and testing of LAMP based applications
1. Ansible scripts for deploying those same applications to a production server, in particular those hosted by [DigitalOcean](https://www.digitalocean.com)

## Installation & Setup

Ideally this repository should be downloaded and configured using the LAMP Setup Script hosted [here](https://github.com/gocodeup/LAMP-Setup-Script). In addition to installing the necessary tools and utilities, it will also create a new SSH key the Ansible scripts will setup for use with the DigitalOcean droplet.

## Creating a Site in Vagrant

When you first run `vagrant up` inside this directory, Vagrant will automatically run the necessary Ansible scripts to configure your test server and setup your first site. Later on in the course if you need to create additional sites you can do so by running:

```
ansible-playbook ansible/site-create.yml -l vagrant -e "domain=<your new domain>"
```

The `site-create.yml` script can also optionally add your new domain to your local hosts file, facilitating the local deployment process. In order to do so however, you must have administer rights and run the script in the following manner:

```
sudo ansible-playbook ansible/site-create.yml -l vagrant -e "domain=<your new domain>" -e "append_host=true"
```

## Setting up a Digital Ocean Server

We use DigitalOcean in part because their signup process is quite straight forward and easy to follow. Simply navigate to the [signup page](https://cloud.digitalocean.com/registrations/new) and follow the prompts.

### Adding a Key

If you used the LAMP Setup Script provided you should have an SSH key generated for you. You must add that key to your DigitalOcean account in order to connect to your server. In order to do so, follow these steps

1. Navigate to the [SSH Keys section](https://cloud.digitalocean.com/ssh_keys) in your DigitalOcean account page.
1. Click "Add SSH Key"
1. Copy the contents of the file `~/.ssh/id_rsa.pub` (hint, you can do this easily by running `cat ~/.ssh/id_rsa.pub | pbcopy`)
1. Give your key a meaningful name (something like "Codeup SSH Key") and then paste your key data into the form.
1. Now save your changes.

### Creating a Droplet

1. Click the [Create](https://cloud.digitalocean.com/droplets/new) button
1. Give your server a meaningful hostname, such as "Codeup-Server"
1. Pretty much all of the default options selected are appropriate for your first droplet (512MB / New York 2 / Ubuntu 14.04)
1. **Make sure you select the option to add your SSH key to your new droplet!**
1. Click create and then wait.
1. Make sure to note your droplet's new IP address

### Editing Local Configs

1. Edit `ansible/hosts` and remove the `;` from the start of the line containing `production`
1. Replace the `xxx.xxx.xxx.xxx` with your droplet's IP address

### Provisioning the Server

Run the following command to initialize your server

```
ansible-playbook ansible/prod-init.yml
```

## Adding a Site to Digital Ocean

Adding a site to your DigitalOcean droplet is similar to adding one to your Vagrant box, although we need to tell Ansible to ask for your password first:

```
ansible-playbook ansible/site-create.yml -l production -e "domain=<your new domain>"  --ask-sudo-pass
```

### Next Steps

1. As the Ansible script runs, two messages with git commands should be outputted. Run those commands from within your application's root directory.
1. The init script created a user called "codeup" in your droplet; you will use this user when SSH-ing into your new server.
1. You must now SSH into your server and run the standard composer and artisan commands to initialize your application.


### Removing a Site

If you wish to remove a site from either your Vagrant box or Digital Ocean server, you can do so using the following ansible command

```
ansible-playbook ansible/site-destroy.yml -l <vagrant|production> -e "domain=<domain to remove>"
```

This command will only remove the configuration files for your site, it will in no way delete any of your files on the server or remove any entries to your hosts file. If you would like to delete the actual files in your site, add the option `-e "purge=true"`. **Be extremely careful with this option! It really will completely wipe your site from the server!** If you wish to delete the site record in your hosts file, run the command with `sudo` and add `-e "purge_host=true"`.

**Note: If you're deleting a site from your Digital Ocean server, you will need to add `--ask-sudo-pass` to the end of these commands**

## Managing MySQL

Included with these files is also a script to aide in setting up MySQL users & databases. In order to create a MySQL administrator, use the following command

```
ansible-playbook ansible/mysql-user-db.yml -l <vagrant|production> -e "mysql_admin=true"
```

To make a new database & user for your application, use the following:

```
ansible-playbook ansible/mysql-user-db.yml -l <vagrant|production> -e "db_name=<databse name>"
```

## Bash Addons

We've created a handful of shortcuts and helpful addons for bash. You can use these functions to make running your ansible commands a bit easier and more intuitive. If you'd like to take advantage of these features do the following:

1. Create/edit a file in your home directory called `.bash_profile` (Hint: `subl ~/.bash_profile`)
1. In that file add the following line:

    ```
    source $HOME/vagrant-lamp/addons.bash
    ```

1. Save and close the file. Close your terminal tab and open a new one to reload your configuration.

The additional functions are:

- `vagrant-create-site` &mdash; Create a new site in your vagrant box
- `prod-create-site` &mdash; Create a new site in your production environment
- `vagrant-create-mysql-admin` &mdash; Create a new MySQL admin user in your vagrant box
- `prod-create-mysql-admin` &mdash; Create a new MySQL admin user in your production environment
- `vagrant-create-mysql-db` &mdash; Create a new MySQL database & user in your vagrant box
- `prod-create-mysql-db` &mdash; Create a new MySQL database & user in your production environment
- `ll` &mdash; Display files in a list format
- `la` &mdash; Display files in a list format, including hidden files
