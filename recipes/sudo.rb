#
# Cookbook:: osl-unmanaged
# Recipe:: sudo
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
package 'sudo'

directory '/etc/sudoers.d' do
  mode '0750'
end

delete_lines 'remove requiretty' do
  path '/etc/sudoers'
  pattern /^.*requiretty/
end

append_if_no_line 'enable includedir' do
  path '/etc/sudoers'
  line '#includedir /etc/sudoers.d'
end
