activefolders Cookbook
==========
This cookbook provisions the ActiveFolders Data Transfer Node and client.

#### activefolders::default
installs a message-of-the-day warning that this node is being managed by chef

#### activefolders::server
Ummm... installs the server bits!  


Requirements
------------
None yet

Attributes
----------
TODO: List you cookbook attributes here.


Usage
-----
Use these steps to provision a node using chef-solo:

* prepare the node by installing chef-solo
```bash
sudo apt-get update
sudo apt-get -y upgrade

# A conflict prevents chef 11 from working with ruby 1.9.
# Here, we replace it with ruby 1.8
sudo apt-get remove ruby1.9.1 --purge
sudo aptitude install -y ruby1.8 ruby1.8-dev libruby1.8 rubygems build-essential wget 

sudo gem update --no-rdoc --no-ri
sudo gem install ohai chef --no-rdoc --no-ri
```

* copy your git key to the node, and configure ssh
```bash
cat << EOF > /home/ubuntu/.ssh/config
UserKnownHostsFile=/dev/null
StrictHostKeyChecking=no
   
Host github.com
   IdentityFile ~/.ssh/github_rsa
EOF
````

* install git, then clone the activefolders repository
```bash
sudo aptitude install -y git
git clone git@github.com:cybera/activefolders-cookbook.git activefolders
````

* run chef-solo!
```bash
sudo chef-solo -c /home/ubuntu/activefolders-cookbook/solo.rb 
````


License and Authors
-------------------
Copyright:: 2014, Cybera, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at


http://www.apache.org/licenses/LICENSE-2.0


Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and 
limitations under the License.
