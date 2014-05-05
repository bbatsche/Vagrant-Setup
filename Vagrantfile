# -*- mode: ruby -*-
# vi: set ft=ruby :

#############################
# Codeup Server Setup
#############################

box      = 'chef/ubuntu-14.04'
hostname = 'codeup-trusty'
domain   = 'codeup.dev'
ip       = '192.168.77.77'
ram      = '512'

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = box

  config.vm.hostname = hostname
  config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.network :private_network, ip: ip

  config.vbguest.auto_update = false if Vagrant.has_plugin? "vagrant-vbguest"

  config.vm.provider :virtualbox do |vb|
    vb.name = hostname

    vb.memory = ram
    vb.cpus = 1

    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["setextradata", :id, "--VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
    vb.customize ["guestproperty", "set", :id, "--timesync-threshold", 10000]
  end

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "ansible/local-server-init.yml"
    ansible.extra_vars = {
      hostname: hostname,
      laravel_env: "local"
    }
  end

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "ansible/local-site-create.yml"
    ansible.extra_vars = {
      domain: domain,
      laravel_env: "local"
    }
  end
end
