#
# Cookbook:: osl-unmanaged
# Recipe:: chrony
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
apt_update 'chrony'

package 'chrony'

append_if_no_line 'Add port 0' do
  path chrony_conf
  line 'port 0'
  sensitive false
  notifies :restart, 'service[chronyd]' unless docker?
end

append_if_no_line 'Add cmdport 0' do
  path chrony_conf
  line 'cmdport 0'
  sensitive false
  notifies :restart, 'service[chronyd]' unless docker?
end

service 'chronyd' do
  if docker?
    action :enable
  else
    action [:enable, :start]
  end
end
