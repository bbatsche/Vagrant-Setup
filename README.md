# Vagrant Lamp Ansible Setup

##1. Either clone or download this repo

	$ cd vagrant-lamp

##2. Once inside directory run the following commands 

	$ vagrant up

	// on mac not vagrant ssh
	$ cd ansible

    $ ansible-playbook -i local_hosts local-site-create.yml -e "domain=codeup.dev"

    // Needed to halt then up again to show shared sync_folder does not show on first load
	$ vagrant halt

	$ vagrant up