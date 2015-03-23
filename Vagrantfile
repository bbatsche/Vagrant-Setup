# -*- mode: ruby -*-
# vi: set ft=ruby :

#############################
# Codeup Server Setup
#############################

box      = 'ubuntu/trusty64'
hostname = 'codeup-trusty'
domain   = 'codeup.dev'
ip       = '192.168.77.77'
ram      = '512'

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = box

  config.vm.hostname = hostname
  config.vm.network :private_network, ip: ip

  config.ssh.insert_key = false

  config.vm.synced_folder "./", "/vagrant", id: "vagrant-root", type: "nfs"

  ## VirtualBox's builtin shared folder technology
  ## Slower than NFS, but does not require admin password
  # config.vm.synced_folder "./", "/vagrant", id: "vagrant-root",
  #     owner: "vagrant",
  #     group: "www-data",
  #     mount_options: ["dmode=775,fmode=664"]

  config.vm.provider :virtualbox do |vb|
    vb.name = hostname

    vb.memory = ram
    vb.cpus = 1

    vb.customize ["modifyvm",             :id, "--natdnshostresolver1", "on"]
    vb.customize ["setextradata",         :id, "--VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
    vb.customize ["guestproperty", "set", :id, "--timesync-threshold",  "1000"]
  end

  config.vm.provision :ansible do |ansible|
    ansible.inventory_path = "ansible/hosts"
    ansible.limit          = "vagrant"
    ansible.playbook       = "ansible/vagrant-init.yml"
    ansible.extra_vars     = { domain: domain }
  end

  # Plugin specific options. Helpful for development but most likely not necessary for class
  if Vagrant.has_plugin? "vagrant-dns"
    config.dns.tld      = "dev"
    config.dns.patterns = [/^.*\.dev$/]
  end
  if Vagrant.has_plugin? "vagrant-cachier"
    config.cache.scope = :box
    config.cache.synced_folder_opts = {
      type: :nfs,
      # The nolock option can be useful for an NFSv3 client that wants to avoid the
      # NLM sideband protocol. Without this option, apt-get might hang if it tries
      # to lock files needed for /var/cache/* operations. All of this can be avoided
      # by using NFSv4 everywhere. Please note that the tcp option is not the default.
      mount_options: ['rw', 'vers=3', 'nolock']
    }
  end
  if Vagrant.has_plugin? "vagrant-reload"
    config.vm.provision :reload
  end
end
