activefolders Cookbook
==========
This cookbook provisions the ActiveFolders Data Transfer Node.

#### activefolders::default
Installs a message-of-the-day warning that this node is being managed by chef

#### activefolders::server
Installs the Data Transfer Node components  


Requirements
------------
* ubuntu Ubuntu 13.10 or later
* python3

Attributes
----------
* `node[:dtnd][:name] = "dtn-name"` - The unique name used to identify this data transfer node
* `node[:dtnd][:repo] = "git@github.com:cybera/activefolders.git@master"` - ActiveFolders source code repository.
* `node[:dtnd][:user] = "ubuntu"` - Linux account used to install and manage ActiveFolders
* `node[:dtnd][:host] = "0.0.0.0"` - ActiveFolders service domain name or ip address
* `node[:dtnd][:listen_port] = 8080` - ActiveFolders service port
* `node[:dtnd][:data_dir] = "/var/lib/activefolders/"` - Installation path for ActiveFolders database and temporary storage for files in transit.


Usage
-----
Use these steps to provision a node using chef-solo:

* prepare the node by installing chef-solo
```bash
sudo apt-get update
sudo apt-get -y upgrade

sudo aptitude install -y ruby ruby-dev libruby rubygems build-essential wget 

sudo gem update --no-rdoc --no-ri
sudo gem install ohai chef --no-rdoc --no-ri
```

* copy your git key to the node, and configure ssh
```bash
cat << EOF > ~/.ssh/config
UserKnownHostsFile=/dev/null
StrictHostKeyChecking=no
   
Host github.com
   IdentityFile ~/.ssh/github_rsa
EOF
````

* install git, then clone the activefolders repository
```bash
sudo aptitude install -y git
git clone git@github.com:cybera/activefolders-cookbook.git
````

* run chef-solo!
```bash
sudo chef-solo -c ~/activefolders-cookbook/solo.rb 
````

Testing
-------
```bash
service dtnd status
````

License and Authors
-------------------
Copyright:: 2014, Paul Lu.

Licensed under the Apache License, Version 2.0 (the "License").
You may not use this file except in compliance with the License. 
You may obtain obtain a copy of the License at


    http://www.apache.org/licenses/LICENSE-2.0


Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and 
limitations under the License.
