# -----------------------------------------------------------------------
# Cookbook Name:: activefolders
# Recipe:: default
# Description::
#
# Copyright 2014, Cybera, inc.
# All rights reserved
#
# Licensed under the GNU General Public License, Version 3.0 (the "License").
# You may not use this file except in compliance with the License. You may
# obtain a copy of the License at
#
# http://www.gnu.org/copyleft/gpl.html
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
# -----------------------------------------------------------------------

template "/etc/motd.tail" do
	source "motd.tail.erb"
end
