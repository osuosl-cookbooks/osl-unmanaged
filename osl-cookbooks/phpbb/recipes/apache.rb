#
# Cookbook Name:: phpbb
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
include_recipe "osl-apache"
include_recipe "apache2::mod_proxy"
include_recipe "apache2::mod_proxy_http"



directory "#{node['apache']['log_dir']}/phpbb.com/access" do
    owner "root"
    group "root"
    mode 00755
    recursive true
    action :create
end
directory "#{node['apache']['log_dir']}/phpbb.com/error" do
    owner "root"
    group "root"
    mode 00755
    recursive true
    action :create
end

remote_directory "sites-available" do
    path "#{node['apache']['dir']}/sites-available"
    source "sites-available" 
    action :create
    notifies :reload, "service[apache2]"
end