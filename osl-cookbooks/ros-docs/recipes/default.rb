#
# Cookbook Name:: ros-docs
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
#
include_recipe 'ros-docs::user'
if node['ros-docs']['glustervol']
  include_recipe 'ros-docs::gluster'
else
  include_recipe 'ros-docs::localmount'
end
include_recipe 'ros-docs::apache'
