# -*- mode: ruby -*-
# vi: set ft=ruby :

#############################
# Development Server Setup
#############################

require 'yaml'

default_config_file = File.join(File.dirname(__FILE__), 'config.yaml.dist')
local_config_file   = File.join(File.dirname(__FILE__), 'config.yaml')

config_data = YAML.load_file default_config_file
config_data = Vagrant::Util::DeepMerge.deep_merge(config_data, YAML.load_file(local_config_file)) if File.exists? local_config_file

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define config_data['hostname'] do |v|
    v.vm.box = config_data['box']

    v.vm.hostname = config_data['hostname']

    v.vm.synced_folder ".", "/vagrant", {
      nfs: true,
      mount_options: ["tcp", "nolock", "actimeo=1", "async"],
      bsd__nfs_options: ["async"]
    }

    v.vm.network "forwarded_port", guest: 5432, host: 5432

    v.vm.provider :virtualbox do |vb, override|
      vb.name = config_data['hostname']

      override.vm.box = config_data['virtualbox_box'] if config_data.has_key? 'virtualbox_box'

      vb.memory = config_data['ram']
      vb.cpus   = config_data['num_cpus']

      vb.customize ["modifyvm",             :id, "--natdnshostresolver1", "on"]
      vb.customize ["setextradata",         :id, "--VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
      vb.customize ["guestproperty", "set", :id, "--timesync-threshold",  "1000"]

      override.vm.network "private_network", type: "dhcp"
    end

    # Configuration options for the VMware Fusion provider.
    v.vm.provider :vmware_fusion do |vmw, override|
      override.vm.box = config_data['vmware_box'] if config_data.has_key? 'vmware_box'

      vmw.vmx["memsize"]  = config_data['ram']
      vmw.vmx["numvcpus"] = config_data['num_cpus']
    end

    # Configuration options for the Parallels provider.
    v.vm.provider :parallels do |p, override|
      p.name = config_data['hostname']

      override.vm.box = config_data['parallels_box'] if config_data.has_key? 'parallels_box'

      p.memory = config_data['ram']
      p.cpus   = config_data['num_cpus']

      p.check_guest_tools  = true
      p.update_guest_tools = true

      p.customize ["set", :id, "--longer-battery-life", "off"]
    end

    v.vm.provision :ansible do |ansible|
      ansible.playbook = "ansible/playbooks/vagrant/init.yml"

      ansible.galaxy_role_file  = "ansible/roles.yml"
      ansible.galaxy_roles_path = "ansible/roles"

      ansible.compatibility_mode = "2.0"

      ansible.extra_vars = config_data["ansible_vars"] if config_data.has_key? "ansible_vars"
    end
  end

  # Plugin specific options. Helpful for development but most likely not necessary for class
  if Vagrant.has_plugin? "vagrant-dnsmasq"
    config.dnsmasq.domain = ".test"

    # overwrite default location for /etc/dnsmasq.conf
    brew_prefix = `/usr/local/bin/brew --prefix`.strip
    config.dnsmasq.dnsmasqconf = brew_prefix + '/etc/dnsmasq.conf'

    # command for reloading dnsmasq after config changes
    config.dnsmasq.reload_command = 'sudo brew services restart dnsmasq'
  end
end
