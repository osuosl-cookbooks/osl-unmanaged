#
# Cookbook:: osl-unmanaged
# Recipe:: powervs
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
include_recipe 'osl-unmanaged::default'
include_recipe 'osl-unmanaged::postfix'

package powervs_pkgs

include_recipe 'osl-unmanaged::network'
include_recipe 'osl-unmanaged::rsct'

package "linux-modules-extra-#{node['kernel']['release']}" if platform_family?('debian') && !docker?

cookbook_file '/etc/multipath.conf'

service 'multipathd' do
  action :enable
end

replace_or_add 'GRUB_TIMEOUT' do
  path '/etc/default/grub'
  pattern /^GRUB_TIMEOUT.*/
  line 'GRUB_TIMEOUT=0'
  sensitive false
  notifies :run, 'execute[rebuild initramfs]'
end unless docker?

replace_or_add 'GRUB_CMDLINE_LINUX' do
  path '/etc/default/grub'
  pattern /^GRUB_CMDLINE_LINUX=.*/
  sensitive false
  replace_only true
  line powervs_grub_cmdline
  notifies :run, 'execute[rebuild initramfs]'
end unless docker?

if platform_family?('rhel')
  package 'dracut'

  file '/etc/dracut.conf.d/10-multipath.conf' do
    content 'force_drivers+=" dm-multipath "'
    notifies :run, 'execute[rebuild initramfs]' unless docker?
  end

  file '/etc/dracut.conf.d/99-powervm.conf' do
    content "force_drivers+=\" #{powervs_modules.join(' ')} \""
    notifies :run, 'execute[rebuild initramfs]'
    only_if { node['kernel']['machine'] == 'ppc64le' }
  end
elsif platform_family?('debian')
  package 'initramfs-tools'

  powervs_modules.each do |m|
    append_if_no_line m do
      path '/etc/initramfs-tools/modules'
      line m
      sensitive false
      notifies :run, 'execute[rebuild initramfs]' unless docker?
    end
  end

  replace_or_add 'initramfs modules-dep' do
    path '/etc/initramfs-tools/initramfs.conf'
    pattern /^MODULES=.*/
    line 'MODULES=dep'
    sensitive false
    notifies :run, 'execute[rebuild initramfs]' unless docker?
  end
end

execute 'rebuild initramfs' do
  if platform_family?('rhel')
    command <<~EOF
      dracut --regenerate-all --force
      dracut --kver #{node['kernel']['release']} --force --add multipath \
        --include /etc/multipath /etc/multipath --include /etc/multipath.conf /etc/multipath.conf
      grub2-mkconfig -o /boot/grub2/grub.cfg
    EOF
  else
    command 'update-initramfs -u && update-grub'
  end
  live_stream true
  action :nothing
end

template '/etc/cloud/cloud.cfg'

file '/etc/cloud/ds-identify.cfg' do
  content 'policy: search,found=all,maybe=all,notfound=disabled'
end

%w(
  cloud-init-local
  cloud-init
  cloud-config
  cloud-final
).each do |s|
  service s do
    action [:stop, :enable]
  end
end
