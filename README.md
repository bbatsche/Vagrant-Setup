# Codeup Vagrant & Ansible Configuration

This repository contains configuration files intended for [Codeup](http://www.codeup.com) students to use throughout their class. It contains:

1. A Vagrantfile for local development and testing of web based applications
1. Ansible playbooks for provisioning development and production servers, and deploying those applications. Primarily targetting servers hosted by [DigitalOcean](https://www.digitalocean.com)

# Installation & Setup

One of the goals for this environment is make set up as simple and straight forward as possible.

## Automated

The easiest way to get started with this repository is using the LAMP Setup Script hosted in [Codeup's GitHub account](https://github.com/gocodeup/LAMP-Setup-Script). In addition to installing the necessary tools and utilities, it will also create an SSH key for Ansible to use with DigitalOcean droplets.

## Manual

Our environment depends on three third party utilities:

- [Vagrant](https://www.vagrantup.com)
- [VirtualBox](https://www.virtualbox.org)
- [Ansible](http://www.ansible.com)

To install these on your Mac, we recommend using [Homebrew](http://brew.sh). Run the following commands in your Terminal or iTerm:

1. Install Homebrew

    ```bash
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    ```

1. Use Homebrew to install Ansible

    ```bash
    brew install ansible
    ```

1. Use Homebrew to install [Cask](http://caskroom.io)

    ```bash
    brew install caskroom/cask/brew-cask
    ```

1. Use Homebrew Cask to install Vagrant and VirutalBox

    ```bash
    brew cask install vagrant
    brew cask install virtualbox
    ```

1. Clone this repository, `cd` into it, and start the Vagrant box with `vagrant up`.

# Ansible Playbooks

Both the Vagrant and production servers can be managed with Ansible using what are called "playbooks". Our playbooks are located in the directory `ansible/playbooks`. The available playbooks are:

    ansible/playbooks
    +-- vagrant
    |   +-- init.yml
    |   +-- sites
    |   |   +-- hhvm.yml
    |   |   +-- node.yml
    |   |   +-- php.yml
    |   |   +-- python2.yml
    |   |   +-- python3.yml
    |   |   +-- ruby.yml
    |   |   +-- static.yml
    |   +-- mysql
    |   |   +-- admin.yml
    |   |   +-- database.yml
    |   |   +-- app
    |   |       +-- hhvm.yml
    |   |       +-- php.yml
    |   |       +-- python2.yml
    |   |       +-- python3.yml
    |   |       +-- ruby.yml
    |   |       +-- wordpress.yml
    |   +-- postgres
    |   |   +-- admin.yml
    |   |   +-- database.yml
    |   |   +-- app
    |   |       +-- php.yml
    |   |       +-- python2.yml
    |   |       +-- python3.yml
    |   |       +-- ruby.yml
    |   +-- mongodb
    |       +-- admin.yml
    |       +-- database.yml
    |       +-- app
    |           +-- node.yml
    +-- production
    |   +-- init.yml
    |   +-- enable-root.yml
    |   +-- sites
    |   |   +-- hhvm.yml
    |   |   +-- node.yml
    |   |   +-- php.yml
    |   |   +-- python.yml
    |   |   +-- ruby.yml
    |   |   +-- static.yml
    |   +-- mysql
    |   |   +-- install.yml
    |   |   +-- admin.yml
    |   |   +-- database.yml
    |   |   +-- app
    |   |       +-- hhvm.yml
    |   |       +-- php.yml
    |   |       +-- python.yml
    |   |       +-- ruby.yml
    |   |       +-- wordpress.yml
    |   +-- postgres
    |   |   +-- install.yml
    |   |   +-- admin.yml
    |   |   +-- database.yml
    |   |   +-- app
    |   |       +-- php.yml
    |   |       +-- python.yml
    |   |       +-- ruby.yml
    |   +-- mongodb
    |       +-- install.yml
    |       +-- admin.yml
    |       +-- database.yml
    |       +-- app
    |           +-- node.yml
    +-- warpspeed
    |   +-- init.yml
    |   +-- sites
    |   |   +-- node.yml
    |   |   +-- php.yml
    |   |   +-- python.yml
    |   |   +-- ruby.yml
    |   |   +-- static.yml
    |   +-- mysql
    |   |   +-- admin.yml
    |   |   +-- database.yml
    |   |   +-- app
    |   |       +-- php.yml
    |   |       +-- python.yml
    |   |       +-- ruby.yml
    |   +-- postgres
    |       +-- admin.yml
    |       +-- database.yml
    |       +-- app
    |           +-- php.yml
    |           +-- python.yml
    |           +-- ruby.yml
    +-- deploy
        +-- node.yml
        +-- php.yml
        +-- python.yml
        +-- ruby.yml

## Vagrant

You should *not* run the `init.yml` playbook by hand; this is done the first time your run `vagrant up` or by running `vagrant provision`.

### Sites

Our Vagrant environment supports creating virtual hosts running PHP (either "static" or "dynamic"), Facebook's HipHop VM, Ruby, Node.js, or Python (either versions 2.7 or 3.4). To create a new site, run one of the following playbooks:

```bash
# Static PHP Site
ansible-playbook ansible/playbooks/vagrant/site/static.yml

# Dynamic PHP Site
ansible-playbook ansible/playbooks/vagrant/site/php.yml

# HipHop VM Site
ansible-playbook ansible/playbooks/vagrant/site/hhvm.yml

# Node.js Site
ansible-playbook ansible/playbooks/vagrant/site/node.yml

# Python 2.7 Site
ansible-playbook ansible/playbooks/vagrant/site/python2.yml

# Python 3.4 Site
ansible-playbook ansible/playbooks/vagrant/site/python3.yml

# Ruby Site
ansible-playbook ansible/playbooks/vagrant/site/ruby.yml
```

These playbooks will first prompt you for a new domain name (all domains in the Vagrant environment must end with `.dev`), install any necessary software, create the required configuration files, and then restart Nginx, if needed.

#### Static vs. Dynamic

A "dynamic" PHP site will route all requests for missing files through `index.php`. This is useful for frameworks such as Laravel. If you are not using such a framework, a "static" site will still execute any PHP file requested directly.

### Database Services

We have included playbooks for managing MySQL, PostgreSQL, and MongoDB database servers. You can use the playbooks either to create a new administrator or databases in any one of these. By default, when these servers are created, Ansible will create a default administrator with the username `vagrant` and password `vagrant`. (_Do **not** delete the `vagrant` user from any of these database servers, otherwise Ansible will no longer be able to manage that service._)

#### Admin

To create a new database administrator in either MySQL, PostgreSQL, or MongoDB run one of the following playbooks:

```bash
# MySQL
ansible-playbook ansible/playbooks/vagrant/mysql/admin.yml

# PostgreSQL
ansible-playbook ansible/playbooks/vagrant/postgres/admin.yml

# MongoDB
ansible-playbook ansible/playbooks/vagrant/mongodb/admin.yml
```

You will first be prompted for a new username and password for your administrator. Ansible will then install any required software and create the requested user.

#### Database

To create a new database in one of the services, run the playbook for the required database type:

```bash
# MySQL
ansible-playbook ansible/playbooks/vagrant/mysql/database.yml

# PostgreSQL
ansible-playbook ansible/playbooks/vagrant/postgres/database.yml

# MongoDB
ansible-playbook ansible/playbooks/vagrant/mongodb/database.yml
```

Ansible will prompt you for the database name, followed by a username and password for an "owner" of that database. Owners are dedicated users that have full control over that database, but no access outside of it. Administrator have access to all databases.

#### App

In addition, there are several shortcut playbooks for creating a database *and* a new site with a single command. These are under the `app` directory for each type of database. Since not all languages support or are well suited for each database flavor, only a subset of sites are available for a given database service.

```bash
# PHP and MySQL App
ansible-playbook ansible/playbooks/vagrant/mysql/app/php.yml

# Wordpress App (this will create a PHP app and download the latest version of Wordpress into it)
ansible-playbook ansible/playbooks/vagrant/mysql/app/wordpress.yml

# HipHop VM and MySQL App
ansible-playbook ansible/playbooks/vagrant/mysql/app/hhvm.yml

# Python 2.7 and MySQL App
ansible-playbook ansible/playbooks/vagrant/mysql/app/python2.yml

# Python 3.4 and MySQL App
ansible-playbook ansible/playbooks/vagrant/mysql/app/python3.yml

# Ruby and MySQL App
ansible-playbook ansible/playbooks/vagrant/mysql/app/ruby.yml

# PHP and PostgreSQL App
ansible-playbook ansible/playbooks/vagrant/postgres/app/php.yml

# Python 2.7 and PostgreSQL App
ansible-playbook ansible/playbooks/vagrant/postgres/app/python2.yml

# Python 3.4 and PostgreSQL App
ansible-playbook ansible/playbooks/vagrant/postgres/app/python3.yml

# Ruby and PostgreSQL App
ansible-playbook ansible/playbooks/vagrant/postgres/app/ruby.yml

# Node.js and MongoDB App
ansible-playbook ansible/playbooks/vagrant/mongodb/app/node.yml
```

These playbooks will first prompt you for a new domain name, followed by a database name, and then the username and password for that database's owner.

## Production

Ansible can be used to manage a production server much in the same way as your Vagrant environment. Our instructions are geared towards [Digital Ocean](https://www.digitalocean.com) servers, but these playbooks should all work with any server running Ubuntu 14.04 (or later).

### Adding your SSH Key

If you used the LAMP Setup Script you should have an SSH key generated for you. You must add that key to your DigitalOcean account in order to connect to your server. To do this, follow these steps

1. Copy your public key using `cat ~/.ssh/id_rsa.pub | pbcopy`.
1. Navigate to the [security settings](https://cloud.digitalocean.com/settings/security) page DigitalOcean.
1. Click "Add SSH Key"
1. Give your key a name (such as "Codeup SSH Key") and then paste your key data into the form.
1. Save your changes

### Creating a Droplet

1. Click the [Create Droplet](https://cloud.digitalocean.com/droplets/new) button
1. Give your server a hostname, such as "Codeup-Server"
1. Typically, we suggest using the base droplet size ($5 / month)
1. We suggest using either the New York or San Fransisco data centers
1. Chose Ubuntu 14.04 x64 as the image.
1. **Make sure to add your SSH key to your new droplet!**
1. Click create and then wait.
1. Make note of your droplet's new IP address

### Configuring Ansible

Ansible needs to know what your droplet's IP address is and how to connect to it. Open the file `ansible/hosts/production`. The second line in there should initially be commented out. Remove the leading `;` to make the line active and replace the `xxx.xxx.xxx.xxx` with your droplet's IP address. Everything else in this file should be fine.

### Provisioning

You will need to use Ansible to create a user account for you on the server, as well as install our core software and configuration files. This is a one-time process. Run the following playbook:

```bash
ansible-playbook ansible/playbooks/production/init.yml
```

You will be prompted for a new sudo password, database admin password, and an eMail address for notifications. Ansible will create an admin user on the server with the same username as your local computer. It will also create a MySQL administrator with the same username. If you are unsure what your computer username is, you can run the command `whoami`.

There is also a playbook to re-enable the root user in production. In most cases, this will not ever be needed and is only included for debugging and development purposes.

```bash
# Re-enable the root user; you should NOT need to run this
ansible-playbook ansible/playbooks/production/enable-root.yml
```

Because Ansible uses your username to create the production user account, to log in to your server all you need to do is run `ssh xxx.xxx.xxx.xxx` where the `xxx.xxx.xxx.xxx` is your server's IP address.

### Sites

Ansible can provision the same types of sites in production as in your Vagrant environment. (_**Note:** Production Python sites use virtualenv, and will use whatever Python binary is included in the environment. Thus, there is no distinction between creating Python 2.7 or 3.4 virtual host._)

```bash
# Static PHP Site
ansible-playbook ansible/playbooks/production/site/static.yml

# Dynamic PHP Site
ansible-playbook ansible/playbooks/production/site/php.yml

# HipHop VM Site
ansible-playbook ansible/playbooks/production/site/hhvm.yml

# Node.js Site
ansible-playbook ansible/playbooks/production/site/node.yml

# Python Site
ansible-playbook ansible/playbooks/production/site/python.yml

# Ruby Site
ansible-playbook ansible/playbooks/production/site/ruby.yml
```

These playbooks will first prompt you for your Sudo password. This is the password you created when initializing your production site. Next you will be asked for the site's domain name, just like with the Vagrant playbooks. Ansible will then install any necessary software and create the required config files.

### Database Services

Ansible can be used to install and/or manage either MySQL, PostgreSQL, or MongoDB database servers in production. However, unlike the Vagrant environment database services must be expressly installed if needed. By default, MySQL server is installed when your server is first set up, but neither PostgreSQL or MongoDB are.

#### Installing

To install any one of the three supported database servers, run the relevant Ansible playbook:

```bash
# Install MySQL Server
ansible-playbook ansible/playbooks/production/mysql/install.yml

# Install PostgreSQL Server
ansible-playbook ansible/playbooks/production/postgres/install.yml

# Install MongoDB Server
ansible-playbook ansible/playbooks/production/mongodb/install.yml
```

These playbooks will first prompt you for your sudo password (which you set up when first creating the server itself) followed by a password for the database administrator. In all three cases, Ansible will create an administrator in the database server with the same username as your local computer, and your production server itself.

#### Admin

If you need to create additional database administrators, you can do so with the following playbooks:

```bash
# Create MySQL Administrator
ansible-playbook ansible/playbooks/production/mysql/admin.yml

# Create PostgreSQL Administrator
ansible-playbook ansible/playbooks/production/postgres/admin.yml

# Create MongoDB Administrator
ansible-playbook ansible/playbooks/production/mongodb/admin.yml
```

These playbooks will prompt you for the database password you created when install the servers, followed by the new administrator username and password.

#### Database

Ansible can be used to create a database in any one of the three database servers, just like the Vagrant environment

```bash
# Create MySQL Database
ansible-playbook ansible/playbooks/production/mysql/database.yml

# Create PostgreSQL Database
ansible-playbook ansible/playbooks/production/postgres/database.yml

# Create MongoDB Database
ansible-playbook ansible/playbooks/production/mongodb/database.yml
```

Like with creating administrators, the playbooks will prompt you for your database password, followed by the name of the new database and a username & password for the database owner.

_**Note:** Ansible will not allow you to create database users with blank passwords in production!_

#### App

Just like the Vagrant playbooks, there are "shortcut" playbooks for creating production sites and databases with a single command:


```bash
# PHP and MySQL App
ansible-playbook ansible/playbooks/production/mysql/app/php.yml

# Wordpress App (this will create a PHP app and download the latest version of Wordpress into it)
ansible-playbook ansible/playbooks/production/mysql/app/wordpress.yml

# HipHop VM and MySQL App
ansible-playbook ansible/playbooks/production/mysql/app/hhvm.yml

# Python and MySQL App
ansible-playbook ansible/playbooks/production/mysql/app/python.yml

# Ruby and MySQL App
ansible-playbook ansible/playbooks/production/mysql/app/ruby.yml

# PHP and PostgreSQL App
ansible-playbook ansible/playbooks/production/postgres/app/php.yml

# Python and PostgreSQL App
ansible-playbook ansible/playbooks/production/postgres/app/python.yml

# Ruby and PostgreSQL App
ansible-playbook ansible/playbooks/production/postgres/app/ruby.yml

# Node.js and MongoDB App
ansible-playbook ansible/playbooks/production/mongodb/app/node.yml
```

You will be asked for:

- Your server's sudo password
- The new domain name
- Your database administrator password
- The new database name
- A username for the database owner
- The password for the database owner

## Warpspeed

If you have created a server using [Warpspeed](https://warpspeed.io) some of your server's features can be managed using Ansible. First though, you must tell Ansible that your server uses Warpspeed. Open `ansible/hosts/production`. At the end of the file you should see the following:

```ini
# ...

[warpspeed]
; digital_ocean ansible_ssh_user=warpspeed
```

Delete the semicolon (`;`) from the beginning of the last line. Now, our playbooks will know your server was created with Warpspeed. Ansible requires some additional software be installed in your server to manage it. To do this, run the following playbook:

```bash
ansible-playbook ansible/playbooks/warpspeed/init.yml
```

Ansible will ask for your sudo password. This password was eMailed to you when you first created the server.

### Sites

If you would like, Ansible can be used to create virtual hosts in your Warpspeed server. The following playbooks can be used to create a site in your Warpspeed server:

```bash
# Static Site
ansible-playbook ansible/playbooks/warpspeed/site/static.yml

# Dynamic PHP Site
ansible-playbook ansible/playbooks/warpspeed/site/php.yml

# HipHop VM Site
ansible-playbook ansible/playbooks/warpspeed/site/hhvm.yml

# Node.js Site
ansible-playbook ansible/playbooks/warpspeed/site/node.yml

# Python Site
ansible-playbook ansible/playbooks/warpspeed/site/python.yml

# Ruby Site
ansible-playbook ansible/playbooks/warpspeed/site/ruby.yml
```

Like the normal production playbooks, Ansible will ask for your sudo password (from your welcome eMail) followed by your new domain name.

#### Notes

1. Unlike servers provisioned by Ansible, static sites in Warpspeed cannot execute PHP code.
1. Warpspeed does not support the latest version(s) of Python, only 2.7.
1. Warpspeed does not include support for Facebook's HipHop VM.

### Database Services

A subset of our database playbooks are supported in Warpspeed. You can use Ansible to manage either MySQL or PostgreSQL database servers:

```bash
# Create a MySQL Administrator
ansible-playbook ansible/playbooks/warpspeed/mysql/admin.yml

# Create a MySQL Database
ansible-playbook ansible/playbooks/warpspeed/mysql/database.yml

# Create a PostgreSQL Administrator
ansible-playbook ansible/playbooks/warpspeed/postgres/admin.yml

# Create a PostgreSQL Database
ansible-playbook ansible/playbooks/warpspeed/postgres/database.yml
```

These playbooks are nearly identical to those for managing production database servers. They will prompt you for the database administrator password. As with the sudo password, this was sent to you via eMail.

#### Notes

1. Just like with the other sets of playbooks, there are also Warpspeed app playbooks for creating PHP, Python, or Ruby sites along side a database.
1. Because Warpspeed uses an outdated version of MongoDB, Ansible cannot be used to manage it, nor can Warpspeed's MongoDB server be easily locked down.
1. The production database playbooks take several steps to secure your servers that are incompatible with Warpspeed, therefore it is not advisable to use the production database playbooks.

## Deployment

When a site is created in production, a remote git repository is also created on your server for pushing code to. Ansible will output a couple of instructions for adding the remote to your local repository and pushing your site to it. The remote URL will look like the following:

    ssh://[username]@[server-ip-address]/var/git/[production-domain].git

When you push your repository to the server, your code will be put in the directory `/srv/www/[production-domain]` where `[production-domain]` is your site's domain name. If you need to do any additional steps to manage your application, such as editing config files or migrating databases, you can `ssh` to your server, `cd` to the site's directory, and manage your application from there.

### Automated

To simplify common deployment tasks, there are four automated deployment playbooks included. These playbooks are designed to deploy web applications written with most popular web application frameworks, including:

- Django
- Express.js
- Flask
- Laravel (versions 4 or 5)
- Lumen
- Rails
- Sails.js
- Sinatra

To use automated deployment, you must first create a "site vars" file. Site vars are stored in `ansible/site_vars` and are written in [YAML](http://www.yaml.org). In that directory you will find a `template.yml`. Make a copy of this file and name it after you site (such as `blog.yml`). In your new site vars file, you must fill in the local domain, production domain, and site type values. If your application depends on any environment variables (such as API keys or database credentials) you can fill those in under the `env_vars` entry. Lastly, if your application is written in Python, you must specify if it uses either version 2.7 or 3.4. Once you are done, save your site vars file. To deploy run one of the four deployment playbooks in `ansible/playbooks/deploy`:

```
# Deploy an application written in Laravel 4, 5, or Lumen
ansible-playbook ansible/playbooks/deploy/php.yml

# Deploy an application written in Express.js or Sails.js
ansible-playbook ansible/playbooks/deploy/node.yml

# Deploy an application written in Django or Flask
ansible-playbook ansible/playbooks/deploy/python.yml

# Deploy an application written in Rails or Sinatra
ansible-playbook ansible/playbooks/deploy/ruby.yml
```

The playbook will prompt you for your site's name, meaning the site vars file name you created without the `.yml` extension. Ansible will read your site vars file, do some basic validation, and then perform the following steps:

- Add the remote to your local git repository
- Push your site to production
- Install any Node or Bower dependencies
- Run the default Gulp and/or Grunt tasks
- Install your framework's dependencies (based on `composer.json/composer.lock`, `Gemfile/Gemfile.lock` or `requirements.txt`)
- Add the environment variables to the site configs
- Migrate the database, if necessary

The goal of these playbooks was to perform as many of the typical application setup steps as possible, while minimizing the risk to existing data. They will not, therefore, do any database seeding even if your framework supports it. You **must** seed your database by hand.

# Vagrant Enhancements (Optional)

The Vagrantfile includes support for some optional Vagrant plugins that can make development quicker and easier. These plugins are not required, but can be useful.

## VB Guest

The [`vagrant-vbguest`](https://github.com/dotless-de/vagrant-vbguest) plugin can automatically update VirtualBox's software in the guest OS. To install, run the following on your Mac:

```bash
vagrant plugin install vagrant-vbguest
```

## DNS

Your Mac can be configured to resolve any domain ending in `.dev` to the Vagrant server. To do this, you must install the [`vagrant-dns`](https://github.com/BerlinVagrant/vagrant-dns) plugin. First, install the plugin itself:

```bash
vagrant plugin install vagrant-dns
```

Then, from the directory containing your vagrant environment, run:

```bash
vagrant dns --install
```

_**Note:** This feature can cause conflicts if two or more Vagrant boxes are running with the same configuration. Use this feature with caution if you have multiple Vagrant environments._

## Cachier

To speed up installation of dependencies and OS packages, you can use the plugin [`vagrant-cachier`](https://github.com/fgrehm/vagrant-cachier). This plugin is configured to cache downloaded software on your local Mac, so that future requests for those files will be resolved from your computer rather than the internet. To install, just run:

```bash
vagrant plugin install vagrant-cachier
```

Then, if your Vagrant environment is already running restart it with:

```bash
vagrant reload
```

## Passwordless NFS Export

For optimal performance, your Mac shares files with the Vagrant environment using NFS. Unfortunately, this requires typing in your password each time you start the box. To avoid this, you can edit your `/etc/sudoers` file to grant access to Vagrant's NFS commands without prompting for a password.

1. Run the following and type in your password when prompted

    ```bash
    sudo visudo
    ```

1. Press `Shift + G` to move to the end of the file
1. Press `o` to create a new line and start editing.
1. Paste the following lines into the file

    ```bash
    Cmnd_Alias VAGRANT_EXPORTS_ADD = /usr/bin/tee -a /etc/exports
    Cmnd_Alias VAGRANT_NFSD = /sbin/nfsd restart
    Cmnd_Alias VAGRANT_EXPORTS_REMOVE = /usr/bin/sed -E -e /*/ d -ibak /etc/exports
    %admin ALL=(root) NOPASSWD: VAGRANT_EXPORTS_ADD, VAGRANT_NFSD, VAGRANT_EXPORTS_REMOVE
    ```

1. Pres `Esc` to leave editing mode
1. Type `:wq` to save the file and exit Vi.

The next time you start your box, you should not need to enter your password.
