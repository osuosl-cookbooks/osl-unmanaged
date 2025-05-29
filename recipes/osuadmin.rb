#
# Cookbook:: osl-unmanaged
# Recipe:: osuadmin
#
# Copyright:: 2022-2025, Oregon State University
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
include_recipe 'osl-unmanaged::sudo'

osuadmin_passwd =
  if ENV['OSUADMIN_PASSWD'].nil?
    node['osl-unmanaged']['osuadmin']['password']
  else
    ENV['OSUADMIN_PASSWD']
  end

# OSU Admin user for support
user 'osuadmin' do
  home '/var/lib/osuadmin'
  shell '/bin/bash'
  password osuadmin_passwd
  manage_home true
  sensitive true
end

directory '/var/lib/osuadmin/.ssh' do
  owner 'osuadmin'
  group 'osuadmin'
  mode '0700'
end

file '/etc/sudoers.d/osuadmin' do
  content '%osuadmin ALL=(ALL) NOPASSWD: ALL'
end

# Setup root user initially with our keys
user 'root' do
  password node['osl-unmanaged']['osuadmin']['password']
  sensitive true
end

directory '/root/.ssh' do
  mode '0700'
end

cookbook_file '/var/lib/osuadmin/.ssh/authorized_keys' do
  source 'authorized_keys.unmanaged'
  owner 'osuadmin'
  group 'osuadmin'
  mode '0600'
end

cookbook_file '/root/.ssh/authorized_keys' do
  source 'authorized_keys.unmanaged'
  mode '0600'
end
