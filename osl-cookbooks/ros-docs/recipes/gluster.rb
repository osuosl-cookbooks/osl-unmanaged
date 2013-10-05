#
# Cookbook Name:: ros-docs
# Recipe:: gluster
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

include_recipe 'base::glusterfs'

# Ensure this is defined
glustervol = node['ros-docs']['glustervol']

if glustervol
  glusterpath = node['ros-docs']['mountpath']
  directory glusterpath
  mount glusterpath do
    device glustervol
    fstype "glusterfs"
    options "defaults,_netdev"
    action [:mount,:enable]
  end
end
