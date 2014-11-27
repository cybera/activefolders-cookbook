# -----------------------------------------------------------------------
# Cookbook Name:: activefolders
# Recipe:: dtnd
# Description::
#
# Copyright 2014, Cybera, inc.
# All rights reserved
#
# Licensed under the Apache License, Version 2.0 (the "License").
# You may not use this file except in compliance with the License. 
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
# -----------------------------------------------------------------------


include_recipe "activefolders::default"

# Install
execute "dpkg" do
  command "dpkg -i --force-all /tmp/globus.deb"
  action :nothing
end

execute "apt" do
  command "apt-get update"
  action :nothing
end

remote_file "install globus repo" do
  path "/tmp/globus.deb"
  source "http://toolkit.globus.org/ftppub/gt5/5.2/5.2.5/installers/repo/globus-repository-5.2-stable-raring_0.0.3_all.deb"
  action :create_if_missing
  notifies :run, "execute[dpkg]", :immediately
  notifies :run, "execute[apt]", :immediately
end

package "python3-pip"
package "globus-gridftp"
package "git"
package "stunnel"

if node[:dtnd][:bottle_dev]
  execute "install bottle" do
  command "pip3 install -e git+git://github.com/defnull/bottle.git#egg=bottle"
  end
end

# Deploy key is used until the repo becomes open
cookbook_file "/root/.ssh/id_rsa" do
  source "deploy_rsa"
  mode 0600
  owner "root"
  group "root"
end

file "/root/.ssh/config" do
  content "Host github.com\n\tStrictHostKeyChecking no\n"
end

execute "install activefolders" do
  command "pip3 install -e git+#{node[:dtnd][:repo]}#egg=activefolders"
end

template "/etc/init.d/dtnd" do
  source "dtnd-init.erb"
  action :create_if_missing
  mode 0755
end

# Define services
service "rsyslog" do
  provider Chef::Provider::Service::Upstart
  supports :restart => true
end

service "globus-gridftp-server" do
  supports :status => true, :restart => true, :reload => true
end

service "dtnd" do
  supports :restart => true
end

service "stunnel4" do
  supports :restart => true, :reload => true
end

# Start
file "/etc/rsyslog.d/10-dtnd.conf" do
  content "local6.*        /var/log/dtnd.log"
  notifies :restart, "service[rsyslog]"
end

template "/etc/gridftp.conf" do
  source "gridftp.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :reload, "service[globus-gridftp-server]"
end

directory "/etc/activefolders" do
  owner "root"
  group "root"
  mode "0755"
end

[node[:dtnd][:data_dir], "#{node[:dtnd][:data_dir]}/storage"].each do |path|
  directory path do
    owner node[:dtnd][:user]
    group node[:dtnd][:user]
    mode "0755"
  end
end

["activefolders", "dtns", "destinations"].each do |conf_file|
  template "/etc/activefolders/#{conf_file}.conf" do
    source "#{conf_file}.conf.erb"
    owner "root"
    group "root"
    mode "0644"
    notifies :enable, "service[dtnd]"
    notifies :restart, "service[dtnd]"
  end
end

%w(server.key server.crt).each do |v|
  cookbook_file "/etc/activefolders/#{v}" do
    notifies :enable, "service[dtnd]"
    notifies :restart, "service[dtnd]"
  end
end

cookbook_file "/etc/default/stunnel4"

cookbook_file "/etc/stunnel/https.conf" do
  notifies :enable, "service[stunnel4]"
  notifies :start, "service[stunnel4]"
end
