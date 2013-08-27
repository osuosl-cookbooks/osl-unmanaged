#
# Cookbook Name:: ros-docs
# Recipe:: apache
#
# Copyright 2013, OSU Open Source Lab
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
#

include_recipe 'firewall::http'
include_recipe 'apache2'

directory node['ros-docs']['logs_dir'] do
  action :create
  owner "apache"
  group "apache"
end

web_app node['ros-docs']['server_name'] do
  server_name node['ros-docs']['server_name']
  unless node['ros-docs']['server_aliases'].nil?
    server_aliases node['ros-docs']['server_aliases']
  end
  docroot node['ros-docs']['docroot']
  logs_dir node['ros-docs']['logs_dir']
end
