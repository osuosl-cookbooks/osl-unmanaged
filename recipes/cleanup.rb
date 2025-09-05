#
# Cookbook:: osl-unmanaged
# Recipe:: cleanup
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
include_recipe 'osl-unmanaged::chrony'

package cleanup_pkgs do
  action :remove
end

if platform_family?('rhel', 'fedora')
  iwl_firmware_pkgs = node['packages'].keys.select { |k, _v| k =~ /iwl.*firmware/ }

  package iwl_firmware_pkgs do
    action :remove
  end

  directory '/etc/udev/rules.d/70-persistent-net.rules' do
    recursive true
    action :delete
    only_if { ::File.directory?('/etc/udev/rules.d/70-persistent-net.rules') }
  end

  file '/etc/udev/rules.d/70-persistent-net.rules' do
    action :delete
    only_if { ::File.file?('/etc/udev/rules.d/70-persistent-net.rules') }
  end

  ifcfg_files.each do |f|
    delete_lines "Remove HWADDR in #{f}" do
      path f
      pattern /^HWADDR.*/
    end
    delete_lines "Remove UUID in #{f}" do
      path f
      pattern /^UUID.*/
    end
  end

  service 'firewalld.service' do
    action [:stop, :disable]
  end

  execute 'dnf clean all' do
    only_if { ::File.exist?('/var/cache/dnf/base.solv') }
  end

elsif platform_family?('debian')
  file '/etc/dpkg/dpkg.cfg.d/excludes' do
    content <<~EOF
      path-exclude=/lib/firmware/*
      path-exclude=/usr/share/doc/linux-firmware/*
    EOF
    notifies :run, 'execute[apt-get reinstall]', :immediately
  end

  package "linux-headers-#{node['kernel']['release']}" do
    action :purge
  end

  package "linux-headers-#{node['kernel']['release'].gsub('-generic', '')}" do
    action :purge
  end

  service 'ufw.service' do
    action [:stop, :disable]
  end

  execute 'apt-get reinstall' do
    command "apt-get -y reinstall #{apt_reinstall_pkgs.join(' ')}"
    action :nothing
  end

  execute 'apt-get -y autoremove' do
    only_if 'apt-get -s autoremove | grep -q REMOVED'
  end

  execute 'apt-get -y clean' do
    not_if { ::Dir['/var/cache/apt/archives/*.deb'].empty? }
  end
end

delete_lines 'Remove packer from /etc/hosts' do
  path '/etc/hosts'
  pattern /127.0.1.1 packer/
end

service 'rpcbind.socket' do
  action [:stop, :disable]
end

# Ensure /etc/resolv.conf doesn't get overwritten by NetworkManager
service 'NetworkManager-cleanup' do
  service_name 'NetworkManager'
  action :stop
end

file '/etc/resolv.conf' do
  content "\n"
  notifies :run, 'execute[truncate /etc/resolv.conf]', :delayed
end

execute 'truncate /etc/resolv.conf' do
  command 'echo > /etc/resolv.conf'
  action :nothing
end
