#
# Cookbook:: osl-unmanaged
# Recipe:: network
#
# Copyright:: 2022-2023, Oregon State University
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

case node['platform_family']
when 'debian'
  apt_update 'network'
  package %w(network-manager isc-dhcp-client netplan.io)

  filter_lines '/etc/NetworkManager/NetworkManager.conf' do
    filters(
      [
        { after: [/\[main\]$/, 'dhcp=internal'] },
        { after: [/\[main\]$/, 'dns=default'] },
        { after: [/\[main\]$/, 'rc-manager=netconfig'] },
        { after: [/\[main\]$/, 'systemd-resolved=false'] },
        { missing: ["[keyfile]\nunmanaged-devices=interface-name:ibmveth3", :after] },
      ]
    )
    sensitive false
    notifies :restart, 'service[NetworkManager]'
  end

  %w(
    90_dpkg
    99-installer
    curtin-preserve-sources
    subiquity-disable-cloudinit-networking
  ).each do |f|
    file "/etc/cloud/cloud.cfg.d/#{f}.cfg" do
      action :delete
    end
  end

  file '/etc/netplan/00-installer-config.yaml' do
    action :delete
    notifies :restart, 'service[NetworkManager]'
  end

  file '/etc/netplan/01-network-manager.yaml' do
    content <<~EOF
      network:
        version: 2
        renderer: NetworkManager
    EOF
    notifies :restart, 'service[NetworkManager]'
    notifies :run, 'execute[netplan apply]', :immediately
  end

  execute 'netplan apply' do
    command 'netplan generate && netplan apply'
    action :nothing
  end

  replace_or_add 'disable DNSStubListener' do
    path '/etc/systemd/resolved.conf'
    pattern '^#DNSStubListener.*'
    line 'DNSStubListener=no'
    sensitive false
    notifies :restart, 'service[NetworkManager]'
  end

  # https://bugs.launchpad.net/ubuntu/+source/isc-dhcp/+bug/1905800
  filter_lines '/etc/apparmor.d/sbin.dhclient' do
    filters(
      [
        { after: [/# NetworkManager$/, '  /run/NetworkManager/dhclient{,6}-*.pid lrw,'] },
        { after: [/# NetworkManager$/, '  owner /proc/*/task/** rw,'] },
      ]
    )
    sensitive false
    notifies :restart, 'service[NetworkManager]'
    notifies :restart, 'service[systemd-networkd]'
    notifies :reload, 'service[apparmor]', :immediately
  end

  file '/etc/resolv.conf' do
    manage_symlink_source
    only_if { ::File.symlink?('/etc/resolv.conf') }
    notifies :restart, 'service[NetworkManager]', :immediately
    action :delete
  end

  execute 'cloud-init clean' do
    only_if { ::File.exist?('/var/lib/cloud/data/instance-id') }
  end

  service 'systemd-resolved.service' do
    action [:stop, :disable]
  end

  service 'NetworkManager' do
    action [:enable, :start]
  end

  service 'apparmor' do
    action :nothing
  end

  service 'systemd-networkd' do
    action :nothing
  end
when 'rhel', 'fedora'
  package %w(dhcp-client NetworkManager)

  filter_lines '/etc/NetworkManager/NetworkManager.conf' do
    filters(
      [
        { after: [/\[main\]$/, 'dhcp=internal'] },
        { after: [/\[main\]$/, 'dns=default'] },
        { after: [/\[main\]$/, 'systemd-resolved=false'] },
      ]
    )
    sensitive false
    notifies :restart, 'service[NetworkManager]'
  end

  replace_or_add 'disable DNSStubListener' do
    path '/etc/systemd/resolved.conf'
    pattern '^#DNSStubListener=.*'
    line 'DNSStubListener=no'
    sensitive false
    notifies :restart, 'service[NetworkManager]'
  end

  service 'systemd-resolved.service' do
    action [:stop, :disable]
  end

  service 'NetworkManager' do
    action [:enable, :start]
  end
end
