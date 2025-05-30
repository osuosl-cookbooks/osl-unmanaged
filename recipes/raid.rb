#
# Cookbook:: osl-unmanaged
# Recipe:: raid
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
include_recipe 'osl-unmanaged::postfix' if raid_pkg.include?('mdadm')

unless raid_pkg.empty?
  if raid_pkg.include?('megacli')
    if platform_family?('debian')
      return if platform?('ubuntu') && node['platform_version'].to_f >= 24.04
      apt_repository 'hwraid' do
        uri 'https://hwraid.le-vert.net/debian'
        components %w(main)
        distribution 'bullseye' if platform?('ubuntu') || node['platform_version'].to_i == 12
        key %w(https://hwraid.le-vert.net/debian/hwraid.le-vert.net.gpg.key)
        only_if { raid_pkg.include?('megacli') }
      end
    elsif platform_family?('rhel', 'fedora')
      remote_file "#{Chef::Config[:file_cache_path]}/megacli.zip" do
        source 'https://docs.broadcom.com/docs-and-downloads/raid-controllers/raid-controllers-common-files/8-07-14_MegaCLI.zip'
        not_if { ::File.exist?('/usr/bin/megacli') }
      end

      archive_file "#{Chef::Config[:file_cache_path]}/megacli.zip" do
        destination "#{Chef::Config[:file_cache_path]}/megacli"
        not_if { ::File.exist?('/usr/bin/megacli') }
      end

      if platform_family?('rhel') && node['platform_version'].to_i >= 9
        remote_file "#{Chef::Config[:file_cache_path]}/ncurses-compat-libs.rpm" do
          source 'https://ftp.osuosl.org/pub/osl/repos/yum/9/x86_64/ncurses-compat-libs-6.2-8.20210508.el9.x86_64.rpm'
          not_if { ::File.exist?('/usr/lib64/libncurses.so.5') }
        end

        package 'ncurses-compat-libs' do
          source "#{Chef::Config[:file_cache_path]}/ncurses-compat-libs.rpm"
          not_if { ::File.exist?('/usr/lib64/libncurses.so.5') }
        end

        file "#{Chef::Config[:file_cache_path]}/ncurses-compat-libs.rpm" do
          action :delete
        end
      elsif node['platform_version'].to_i == 8
        package 'ncurses-compat-libs'
      end

      package 'megacli' do
        source "#{Chef::Config[:file_cache_path]}/megacli/Linux/MegaCli-8.07.14-1.noarch.rpm"
        not_if { ::File.exist?('/usr/bin/megacli') }
      end

      execute 'megacli alternatives' do
        command <<~EOL
          alternatives --install '/usr/bin/MegaCli64' 'MegaCli64' '/opt/MegaRAID/MegaCli/MegaCli64' 1
          alternatives --install '/usr/bin/MegaCli' 'MegaCli' '/opt/MegaRAID/MegaCli/MegaCli64' 1
          alternatives --install '/usr/bin/megacli' 'megacli' '/opt/MegaRAID/MegaCli/MegaCli64' 1
        EOL
        creates '/usr/bin/megacli'
      end

      file "#{Chef::Config[:file_cache_path]}/megacli.rpm" do
        action :delete
      end
    end

    package raid_pkg if platform_family?('debian')
  end

  if raid_pkg.include?('mdadm')
    package raid_pkg

    file mdadm_conf do
      action :create_if_missing
    end

    replace_or_add 'mdadm MAILADDR' do
      path mdadm_conf
      pattern /^MAILADDR.*/
      line 'MAILADDR mdadm@osuosl.org'
      sensitive false
    end

    if platform_family?('rhel', 'fedora')
      service 'mdmonitor-oneshot.service' do
        action :enable
      end
      service 'mdmonitor-oneshot.timer' do
        action [:enable, :start]
      end
    else
      service 'mdmonitor.service' do
        action [:enable, :start]
      end
    end
  end
end
