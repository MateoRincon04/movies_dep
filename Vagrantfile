#Vagrant.configure("2") do |config|
#
#  VMServers = [
#    {
#      :hostname => "BackEndVM"
#      :box => "centos/8"
#      :ip => "192.168.139.1",
#      :script => "backend.sh"
#    },
#
#    {
#      :hostname => "FrontEndVM"
#      :box => "centos/8"
#      :ip => "192.168.139.2",
#      :script => "frontend.sh"
#    }
#  ]
#
#  # General config for each VM in VMServers
#  VMServers.each do |machine|
#    config.vm.define machine[:hostname] do |node|
#      node.vm.box = machine[:box]
#      node.vm.hostname = machine[:hostname]
#      node.vm.network :private_network, ip: machine[:ip]
#      node.vm.provision :shell, path: machine[:script]
#
#      node.vm.provider "virtualbox" do |vb|
#        vb.linked_clone = true
#        vb.memory = 1024
#        vb.cpus = 2
#
#      end
#    end
#  end
#end


Vagrant.configure("2") do |config|

  config.vm.define "Backend" do |be|
    be.vm.box = 'generic/ubuntu1804'
    be.vm.synced_folder '.', '/vagrant', disabled: true
    be.vm.hostname = 'BackEndVM'
    be.vm.network "private_network", ip: '192.168.56.1'
    be.vm.provision :shell, path: 'backend.sh'
    be.vm.provider "virtualbox" do |vb|
      vb.linked_clone = true
      vb.memory = 1024
      vb.cpus = 2
    end
  end

  config.vm.define "Frontend" do |fe|
    fe.vm.box = 'generic/ubuntu1804'
    fe.vm.synced_folder '.', '/vagrant', disabled: true
    fe.vm.hostname = 'FrontEndVM'
    fe.vm.network "private_network", ip: '192.168.56.2'
    fe.vm.provision :shell, path: 'frontend.sh'
    fe.vm.provider "virtualbox" do |vb|
      vb.linked_clone = true
      vb.memory = 1024
      vb.cpus = 2
    end
  end



end
