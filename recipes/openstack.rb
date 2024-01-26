#
# Cookbook:: osl-unmanaged
# Recipe:: openstack
#
# Copyright:: 2022-2024, Oregon State University
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
apt_update 'openstack' if platform_family?('debian')

include_recipe 'osl-unmanaged::default'

package openstack_pkgs

include_recipe 'osl-unmanaged::network'

replace_or_add 'GRUB_TIMEOUT' do
  path '/etc/default/grub'
  pattern /^GRUB_TIMEOUT=.*/
  line 'GRUB_TIMEOUT=0'
  sensitive false
  notifies :run, 'execute[rebuild initramfs]'
end

replace_or_add 'GRUB_CMDLINE_LINUX' do
  path '/etc/default/grub'
  pattern /^GRUB_CMDLINE_LINUX=.*/
  sensitive false
  replace_only true
  line openstack_grub_cmdline
  notifies :run, 'execute[rebuild initramfs]'
end

if platform_family?('rhel', 'fedora')
  filter_lines '/etc/cloud/cloud.cfg' do
    filters(
      [
        { substitute: [/name: cloud-user$/, /cloud-user/, node['platform']],
        },
        # Remove trailing white space
        { substitute: [
            /\s$/,
            /\s$/,
            '',
          ],
        },
      ]
    )
    sensitive false
  end
elsif platform?('ubuntu')
  filter_lines '/etc/cloud/cloud.cfg' do
    filters(
      [
        { substitute: [
            %r{primary: https?://archive.ubuntu.com/ubuntu},
            %r{https?://archive.ubuntu.com/ubuntu/?},
            'https://ubuntu.osuosl.org/ubuntu',
          ],
        },
      ]
    )
    sensitive false
  end
elsif platform?('debian')
  filter_lines '/etc/cloud/cloud.cfg' do
    filters(
      [
        # Remove trailing white space
        { substitute: [
            /\s$/,
            /\s$/,
            '',
          ],
        },
      ]
    )
    sensitive false
  end
end

cookbook_file '/etc/cloud/cloud.cfg.d/91_openstack_override.cfg' do
  case node['platform_family']
  when 'debian'
    source '91_openstack_override.cfg-debian'
  when 'rhel', 'fedora'
    source '91_openstack_override.cfg-rhel'
  end
end

%w(
  cloud-init-local
  cloud-init
  cloud-config
  cloud-final
).each do |s|
  service s do
    action :enable
  end
end

execute 'rebuild initramfs' do
  command openstack_grub_mkconfig
  live_stream true
  action :nothing
end

# TODO: Workaround issue with Debian booting on aarch64
directory '/boot/efi/EFI/boot' if ::File.exist?('/boot/efi/EFI/debian/grubaa64.efi')

remote_file '/boot/efi/EFI/boot/bootaa64.efi' do
  source 'file:///boot/efi/EFI/debian/grubaa64.efi'
end if ::File.exist?('/boot/efi/EFI/debian/grubaa64.efi')
