#
# Cookbook Name:: ros
# Recipe:: rosbot
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

# Add the ssh keys
node.set['ros-docs']['ssh_keys'] = [
  'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA8p1T/K+U8I3gbtl1ba7zdu/H3YIFRKpOrUzgLyiRylZQ1i7+tuoWPpH0SNj4jClUGxsj7RjqZgzaFmU9Dwoi7GNDpbd37gGzs56OoKrI7momZFuva/moot7OQvfl8lF5EA9oLq3fPE15rksZVjGt5Xu4Zk98LI9NA2r9yC61tD0LyIrEcOpXXnJjIWJI7WrmNXi9e7T29N6l/PuLEskSgtnRkXgJlB79nnuhxGPvAwDB2bQ18YGkpmz4goDdUvAK/A64CbP9CWupJS20A3R+hOKegYMIwdqVjuOpPLQViHqDro0cJe+Km8C1zTY4SInj9qxZ7XgccP8RO8JU7xVkvw== rosbuild@bf2.willowgarage.com'
]

# Configure the volume mount point
node.set['ros-docs']['glustervol'] = 'fs3.osuosl.bak:/ros-docs'

# Apache configuration
node.set['ros-docs']['server_name'] = 'docs.ros.org'
node.set['ros-docs']['server_aliases'] = [
  'doc.ros.org',
  'docs.ros.osuosl.org',
  'doc.ros.osuosl.org'
]

# Include the relevant recipes
include_recipe 'ros-docs'
