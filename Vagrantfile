# -*- mode: ruby -*-
# vi: set ft=ruby :

#############################
# Codeup Server Setup
#############################

box      = 'chef/ubuntu-14.04'
hostname = 'trusty'
domain   = 'codeup.dev'
ip       = '192.168.77.77'
ram      = '512'

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = box

  config.vm.host_name = hostname
  config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.network :private_network, ip: ip
  config.vbguest.auto_update = false

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--name", hostname]
    vb.customize ["modifyvm", :id, "--memory", ram]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["setextradata", :id, "--VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
  end

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "ansible/local-server-init.yml"
    ansible.limit = "all"
    ansible.host_key_checking = false
  end

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "ansible/local-site-create.yml"
    ansible.limit = "all"
    ansible.host_key_checking = false
  end

end