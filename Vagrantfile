# -*- mode: ruby -*-
# vi: set ft=ruby :

#############################
# Codeup Server Setup
#############################

box      = 'parallels/ubuntu-14.04'
hostname = 'vagrantbox'
ip       = '10.211.55.2'
ram      = '1024'
timezone = 'America/Chicago'

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define "vagrant" do |v|
    v.vm.box = box

    v.vm.hostname = hostname

    v.vm.synced_folder "./sites", "/srv/www"
    v.vm.synced_folder ".", "/vagrant", disabled: true

    v.vm.provider :parallels do |p|
      p.name = hostname

      p.check_guest_tools  = true
      p.update_guest_tools = true

      p.memory = ram
      p.cpus   = 1
    end

    v.vm.provision :ansible do |ansible|
      ansible.playbook = "playbooks/vagrant/init.yml"
      ansible.extra_vars = {
        timezone: timezone,
        mysql_admin: "root",
        mysql_pass: '',
        new_mysql_user: "vagrant",
        new_mysql_pass: "vagrant"
      }
    end
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
