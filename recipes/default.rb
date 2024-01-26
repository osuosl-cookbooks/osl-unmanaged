#
# Cookbook:: osl-unmanaged
# Recipe:: default
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
include_recipe 'osl-unmanaged::repos'
include_recipe 'osl-unmanaged::packages'
include_recipe 'osl-unmanaged::ssh'
include_recipe 'osl-unmanaged::sudo'
include_recipe 'osl-unmanaged::osuadmin'
include_recipe 'osl-unmanaged::chrony'
include_recipe 'osl-unmanaged::postfix'
include_recipe 'osl-unmanaged::fail2ban'
include_recipe 'osl-unmanaged::raid'
include_recipe 'osl-unmanaged::rsct' if rsct_enabled
