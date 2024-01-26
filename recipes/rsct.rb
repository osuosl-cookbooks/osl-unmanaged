#
# Cookbook:: osl-unmanaged
# Recipe:: rsct
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
if platform_family?('rhel', 'fedora')
  remote_file "#{Chef::Config[:file_cache_path]}/ibm-power-repo.rpm" do
    source 'https://public.dhe.ibm.com/software/server/POWER/Linux/yum/download/ibm-power-repo-latest.noarch.rpm'
    not_if { ::File.exist?('/opt/ibm/lop/configure') }
  end

  package 'ibm-power-repo' do
    source "#{Chef::Config[:file_cache_path]}/ibm-power-repo.rpm"
    not_if { ::File.exist?('/opt/ibm/lop/configure') }
  end

  file "#{Chef::Config[:file_cache_path]}/ibm-power-repo.rpm" do
    action :delete
  end

  file '/etc/motd' do
    content ''
  end

  yum_repository 'IBM_Power_Tools' do
    baseurl ibm_yum_repo_url
    gpgkey 'file:///opt/ibm/lop/gpg/RPM-GPG-KEY-ibm-power'
  end

  if ppc64le?
    package ibm_pkgs

    # This needs to be installed _after_ the other packages
    package 'DynamicRM'
  end
else
  apt_repository 'IBM_Power_Tools' do
    uri 'ppa:ibmpackages/rsct'
    distribution 'focal' if platform?('debian')
  end

  if ppc64le?
    package ibm_pkgs

    # This needs to be installed _after_ the other packages
    # This not currently included in the repository for 22.04 so pull this deb from the focal repo
    remote_file "#{Chef::Config[:file_cache_path]}/dynamicrm.deb" do
      source 'https://launchpad.net/~ibmpackages/+archive/ubuntu/rsct/+files/dynamicrm_2.0.7.3-23-1ubuntu1_ppc64el.deb'
      not_if { ::File.exist?('/opt/rsct/bin/IBM.DRMd') }
    end

    dpkg_package 'dynamicrm' do
      source "#{Chef::Config[:file_cache_path]}/dynamicrm.deb"
      not_if { ::File.exist?('/opt/rsct/bin/IBM.DRMd') }
    end

    file "#{Chef::Config[:file_cache_path]}/dynamicrm.deb" do
      action :delete
    end
  end
end
