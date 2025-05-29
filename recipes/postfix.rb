#
# Cookbook:: osl-unmanaged
# Recipe:: postfix
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

package %w(exim4-base exim4-config exim4-daemon-light) do
  action :purge
end if platform_family?('debian')

package 'postfix'

replace_or_add 'inet_interfaces' do
  path '/etc/postfix/main.cf'
  pattern /^inet_interfaces/
  line 'inet_interfaces = loopback-only'
  sensitive false
  notifies :restart, 'service[postfix]'
end

replace_or_add 'relayhost' do
  path '/etc/postfix/main.cf'
  pattern /^relayhost/
  line 'relayhost = [smtp.osuosl.org]:25'
  sensitive false
  notifies :restart, 'service[postfix]'
end

delete_lines 'myhostname' do
  path '/etc/postfix/main.cf'
  pattern /^myhostname/
  sensitive false
  notifies :restart, 'service[postfix]'
end

delete_lines 'mydestination' do
  path '/etc/postfix/main.cf'
  pattern /^mydestination/
  sensitive false
  notifies :restart, 'service[postfix]'
end

service 'postfix' do
  action [:enable, :start]
end
