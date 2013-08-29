#
# Cookbook Name:: ros
# Recipe:: default
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

directory "/var/www/planet.ros.org/htdocs" do
	mode 0775
	recursive true
	group "alfred"
	owner "alfred"
end

# install yaml using pear LWRP
# required for ros/browse/list.php
include_recipe "php"
include_recipe "build-essential"
package "libyaml-devel"
php_pear "yaml" do
  action :install
end

# Gives the ROS user the ability to reload apache with sudo
node.default['authorization']['sudo']['include_sudoers_d'] = true
sudo 'ros' do
  user      'ros'
  runas     'root'
  nopasswd  true
  commands  ['/sbin/service httpd reload']
end

cron_d "dump_wiki" do
	minute 13
	hour 12
	weekday 6
	command "/var/www/wiki.ros.org/dump_wiki > /dev/null 2> /dev/null"
end
