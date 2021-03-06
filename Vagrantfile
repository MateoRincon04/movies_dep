Vagrant.configure("2") do |config|

  config.vm.define :loadbalancer do |loadbalancer|
    loadbalancer.vm.provider :virtualbox do |v|
        v.linked_clone = true
        v.name = "loadbalancer"
        v.customize [
            "modifyvm", :id,
            "--name", "loadbalancer",
            "--memory", 512,
            "--natdnshostresolver1", "on",
            "--cpus", 1,
        ]
    end
    loadbalancer.vm.box = "generic/ubuntu1804"
    loadbalancer.vm.network :private_network, ip: "192.168.56.10"
    loadbalancer.vm.provision "file", source: "~/movies_dep/nginx.conf", destination: "nginx.conf"
    loadbalancer.vm.provision :shell, path: 'loadbalancersscript.sh'
    loadbalancer.ssh.forward_agent = true
    loadbalancer.vm.synced_folder '.', '/vagrant', disabled: true
  end

  (1..2).each do |i|
    config.vm.define "backend_#{i}" do |backend|
        backend.vm.provider :virtualbox do |v|
            v.linked_clone = true
            v.name = "backend_#{i}"
            v.customize [
                "modifyvm", :id,
                "--name", "backend_#{i}",
                "--memory", 512,
                "--natdnshostresolver1", "on",
                "--cpus", 1,
            ]
        end

        backend.vm.box = "generic/ubuntu1804"
        backend.vm.network :private_network, ip: "192.168.56.#{i+1}"
        backend.vm.provision :shell, path: 'backend.sh', env: {"PORT"=>ENV['PORT'], "DB_PASS"=>ENV['DB_PASS'], "DB_HOST"=>ENV['DB_HOST'], "DB_USER"=>ENV['DB_USER'], "DB_NAME"=>ENV['DB_NAME']}
        backend.ssh.forward_agent = true
        backend.vm.synced_folder '.', '/vagrant', disabled: true
    end

    config.vm.define "frontend_#{i}" do |frontend|
      frontend.vm.provider :virtualbox do |v|
          v.linked_clone = true
          v.name = "frontend_#{i}"
          v.customize [
              "modifyvm", :id,
              "--name", "frontend_#{i}",
              "--memory", 512,
              "--natdnshostresolver1", "on",
              "--cpus", 1,
          ]
      end

      frontend.vm.box = "generic/ubuntu1804"
      frontend.vm.network :private_network, ip: "192.168.56.1#{i}"
      frontend.vm.provision :shell, path: 'frontend.sh', env: {"BACK_HOST"=>ENV['BACK_HOST']}
      frontend.ssh.forward_agent = true
      frontend.vm.synced_folder '.', '/vagrant', disabled: true
    end
  end

  config.vm.define :loadbalancerfront do |lbf|
    lbf.vm.provider :virtualbox do |v|
        v.linked_clone = true
        v.name = "loadbalancerfront"
        v.customize [
            "modifyvm", :id,
            "--name", "loadbalancerfront",
            "--memory", 512,
            "--natdnshostresolver1", "on",
            "--cpus", 1,
        ]
    end
    lbf.vm.box = "generic/ubuntu1804"
    lbf.vm.network :private_network, ip: "192.168.56.20"
    # lbf.vm.network :public_network, ip: IP PUBLICA
    lbf.vm.provision "file", source: "~/movies_dep/nginxfront.conf", destination: "nginx.conf"
    lbf.vm.provision :shell, path: 'loadbalancersscript.sh'
    lbf.ssh.forward_agent = true
    lbf.vm.synced_folder '.', '/vagrant', disabled: true
  end

  config.vm.define :database do |db|
    db.vm.provider :virtualbox do |v|
        v.linked_clone = true
        v.name = "database"
        v.customize [
            "modifyvm", :id,
            "--name", "database",
            "--memory", 512,
            "--natdnshostresolver1", "on",
            "--cpus", 1,
        ]
    end
    db.vm.box = "generic/ubuntu1804"
    db.vm.network :private_network, ip: "192.168.56.5"
    db.vm.network "forwarded_port", guest: 3306, host: 3306
    db.vm.provision :shell, path: 'database.sh'
    db.ssh.forward_agent = true
    db.vm.synced_folder '.', '/vagrant', disabled: true
  end
end
