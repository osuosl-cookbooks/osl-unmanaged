#
# Cookbook:: osl-unmanaged
# Recipe:: fail2ban
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
include_recipe 'osl-unmanaged::postfix'
include_recipe 'osl-unmanaged::repos'

if platform_family?('fedora')
  package %w(fail2ban iptables-legacy)
else
  package %w(fail2ban iptables)
end

cookbook_file '/etc/fail2ban/jail.local'

file '/var/log/auth.log' do
  action :create_if_missing
end if docker?

service 'fail2ban' do
  action [:enable, :start]
end
