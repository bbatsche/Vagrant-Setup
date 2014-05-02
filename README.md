# Vagrant Lamp Ansible Setup

	$ vagrant up

After install

	// Needed to halt then up again to show shared sync_folder does not show on first load
	$ vagrant halt

	$ vagrant up

	// on mac not vagrant ssh
	$ cd ansible

    $ ansible-playbook -i local_hosts local-site-create.yml -e "domain=codeup.dev"

    $ vagrant ssh

    // once in vm
    $ sudo service nginx restart