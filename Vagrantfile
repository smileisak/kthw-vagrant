
masters = [
    { :hostname => 'master1', :ram => 1024, :ip => "10.0.0.200"},
  ]


workers = [
  { :hostname => 'worker1', :ram => 1024, :ip => "10.0.0.201"},
]

  
  Vagrant.configure("2") do |config|
    masters.each do |node|
      config.vm.define node[:hostname] do |nodeconfig|
        nodeconfig.vm.network "private_network", ip: node[:ip]
        nodeconfig.vm.box = "bento/ubuntu-16.04";
        nodeconfig.vm.hostname = node[:hostname]
        memory = node[:ram] ? node[:ram] : 256;
        nodeconfig.vm.synced_folder "./", "/vagrant"
        
        #nodeconfig.vm.provision "shell", path: "provision/etcd/provision-etcd.sh"
        #nodeconfig.vm.provision "shell", path: "provision/master/provision-master.sh"
        nodeconfig.vm.provision "shell", path: "provision/master/rbac.sh"
        
        nodeconfig.vm.provider :virtualbox do |vb|
          vb.customize [
            "modifyvm", :id,
            "--memory", memory.to_s,
            "--cpus", "1"
          ]
        end
      end
    end

    workers.each do |node|
      config.vm.define node[:hostname] do |nodeconfig|
        nodeconfig.vm.network "private_network", ip: node[:ip]
        nodeconfig.vm.box = "bento/ubuntu-16.04";
        nodeconfig.vm.hostname = node[:hostname]
        memory = node[:ram] ? node[:ram] : 256;
        nodeconfig.vm.synced_folder "./", "/vagrant"
        #nodeconfig.vm.provision "shell", path: "provision.sh"
        nodeconfig.vm.provision "shell", path: "provision/worker/provision-worker.sh"
  
        nodeconfig.vm.provider :virtualbox do |vb|
          vb.customize [
            "modifyvm", :id,
            "--memory", memory.to_s,
            "--cpus", "1"
          ]
        end
      end
    end
    
  end
  