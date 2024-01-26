#
# Cookbook:: osl-unmanaged
# Recipe:: ssh
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
package openssh_pkgs

unmanaged_sshd_config.each do |key, value|
  replace_or_add key do
    path '/etc/ssh/sshd_config'
    pattern "^#{key}.*"
    line "#{key} #{value}"
    sensitive false
    notifies :restart, 'service[sshd]'
  end
end

service 'sshd' do
  action [:enable, :start]
end
