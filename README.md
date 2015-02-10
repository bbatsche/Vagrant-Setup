# Codeup Vagrant Box & Ansible Scripts

This repository contains files and scripts intended for [Codeup](http://www.codeup.com) students to use throughout their class. It contains:

1. A Vagrantfile definition for local development and testing of LAMP based applications
1. Ansible scripts for deploying those same applications to a production server, in particular those hosted by [DigitalOcean](https://www.digitalocean.com)

## Installation & Setup

Ideally this repository should be downloaded and configured using the LAMP Setup Script hosted [here](https://github.com/gocodeup/LAMP-Setup-Script). In addition to installing the necessary tools and utilities, it will also create a new SSH key the Ansible scripts will setup for use with the DigitalOcean droplet.

## Ansible Scripts

Included with this repository is a set of scripts for managing either your vagrant or production environments. You can run these scripts from directly on your Mac and Ansible will go into either your Vagrant or production server and perform whatever the required tasks are. We will go into more detail on how to use many of these scripts, but the following is an overview of the included items.

- `vagrant-init.yml`
  - Set up the vagrant environment. You should **not** run this script directly; `vagrant up` or `vagrant provision` will run it for you.
- `prod-init.yml`
  - Set up a production environment. It will create a new commandline (console) user and a new MySQL administrator, both called `codeup`. You will be prompted to provide a new password for both. These are the passwords you will use in subsequent `sudo` or database admin tasks.
- `warpspeed-init.yml`
  - If you have created a production server using Warpspeed, this script will add a couple of additional utilities and config files so that ansible can also manage that server. Requires the `--ask-sudo-pass` flag.
- `create-vagrant-site.yml`
  - Create a new site within the Vagrant environment.
- `create-vagrant-mysql-admin.yml`
  - Create a new MySQL user in the Vagrant environment with database wide admin privileges.
- `create-vagrant-mysql-db.yml`
  - Create a new MySQL database in the Vagrant environment and a dedicated user for it. This user will have full privileges for the database but no access to any others.
- `destroy-vagrant-site.yml`
  - Disable a site in the Vagrant environment. Will not delete any user files unless a `purge` flag is passed.
- `create-production-site.yml`
  - Create a new site within the production environment. Will setup git hooks so that you can push your site to production using `git`. Requires the `--ask-sudo-pass` flag.
- `create-production-mysql-admin.yml`
  - Create a new MySQL user in the production environment with database wide admin privileges.
- `create-production-mysql-db.yml`
  - Create a new MySQL database in the production environment and a dedicated user for it. This user will have full privileges for the database but no access to any others.
- `create-production-app.yml`
  - Combination of the `create-production-site.yml` and `create-production-mysql-db.yml` scripts, for setting up a new site and a dedicated database & user for it. Just like above, it will create git hooks for push deployment. Requires the `--ask-sudo-pass` flag.
- `deploy-site.yml`
  - Push a local site to production using git. You will be prompted for a site to deploy; this is the name of a config file inside `ansible/sites` you need to create first. Look at the file `template.yml` for some instructions.
- `destroy-production-site.yml`
  - Disable a site in the production environment. Will not delete any user files unless a `purge` flag is passed. Requires the `--ask-sudo-pass` flag.

## Creating a Site in Vagrant

When you first run `vagrant up` inside this directory, Vagrant will automatically run the necessary Ansible scripts to configure your test server and setup your first site. Later on in the course if you need to create additional sites you can do so by running:

```bash
ansible-playbook ansible/create-vagrant-site.yml
```

The `create-vagrant-site.yml` script can also optionally add your new domain to your local hosts file, facilitating the local deployment process. In order to do so however, you must have administer rights and run the script in the following manner:

```bash
sudo ansible-playbook ansible/create-vagrant-site.yml -e "append_host=true"
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

```bash
ansible-playbook ansible/prod-init.yml
```

This will guide you through the process of setting up the site, as well as initializing a site on your server. You will need to provide it:

- A password for the default console or shell user, "codeup"
- An eMail address to receive notifications from the server
- A username and password for a default MySQL administrator
- A domain name for your site
- A database name for your application
- A database username and password for your application to use

## Adding a Site to Digital Ocean

Adding a site to your DigitalOcean droplet is similar to adding one to your Vagrant box, although we need to tell Ansible to ask for your password first:

```bash
ansible-playbook ansible/create-production-site.yml --ask-sudo-pass
```

### Next Steps

1. As the Ansible script runs, two messages with git commands should be outputted. Run those commands from within your application's root directory.
1. The init script created a user called "codeup" in your droplet; you will use this user when SSH-ing into your new server.
1. You must now SSH into your server and run the standard composer and artisan commands to initialize your application.


### Removing a Site

If you wish to remove a site from either your Vagrant box or Digital Ocean server, you can do so using the following ansible commands

```bash
ansible-playbook ansible/destroy-vagrant-site.yml
# or
ansible-playbook ansible/destroy-production-site.yml --ask-sudo-pass
```

This command will only remove the configuration files for your site, it will in no way delete any of your files on the server or remove any entries to your hosts file. If you would like to delete the actual files in your site, add the option `-e "purge=true"`. **Be extremely careful with this option! It really will completely wipe your site from the server!** If you wish to delete the site record in your hosts file, run the command with `sudo` and add `-e "purge_host=true"`.

**Note: If you're deleting a site from your Digital Ocean server, you will need to add `--ask-sudo-pass` to the end of these commands**

## Managing MySQL

Included with these files is also a script to aide in setting up MySQL users & databases. In order to create a MySQL administrator, use the following command

```bash
ansible-playbook ansible/create-vagrant-mysql-admin.yml
# or
ansible-playbook ansible/create-production-mysql-admin.yml
```

To make a new database & user for your application, use the following:

```bash
ansible-playbook ansible/create-vagrant-mysql-db.yml
# or
ansible-playbook ansible/create-production-mysql-db.yml
```
