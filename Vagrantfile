# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.network "forwarded_port", guest: 443, host: 8081
  config.vm.synced_folder "../af-", "/tmp/src"

  # config.vm.network "public_network"
  # config.ssh.forward_agent = true

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--memory", "1024"]
    vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
  end

  config.vm.provision "chef_solo" do |chef|
    chef.add_recipe "active-folders::dtnd"
    chef.json = {
      :dtnd => {
        :user => "vagrant",
        :repo => "file:///tmp/src@master"
      }
    }
  end

end
