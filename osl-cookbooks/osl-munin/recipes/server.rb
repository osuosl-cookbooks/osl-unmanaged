#
# Cookbook Name:: osl-munin
# Recipe:: client
#
# Copyright (C) 2013 OSU Open Source Lab
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

directory node['osl-munin']['muninpath']
mount node['osl-munin']['muninpath'] do
  device node['osl-munin']['munindevice']
  fstype node['osl-munin']['muninfstype']
  options node['osl-munin']['muninfsopts']
  action [:mount, :enable]
  only_if "test -b #{node['osl-munin']['munindevice']}"
end

node.set['munin']['server_auth_method'] = 'htauth'
node.set['munin']['server_role'] = 'munin'
node.set['munin']['public_domain'] = 'munin2.osuosl.org'
node.set['munin']['web_server'] = 'nginx'

include_recipe 'osl-nginx::repo'
include_recipe 'munin::server'
include_recipe 'firewall::http'
include_recipe 'firewall::munin'
