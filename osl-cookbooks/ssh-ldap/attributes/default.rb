#
# Cookbook Name:: ssh-ldap
# Attributes:: default
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
# Attributes are commented out using the default config file values.
# Uncomment the ones you need, or set attributes in a role.
#

default['openssh']['server']['authorized_keys_command'] = "/usr/libexec/openssh/ssh-ldap-wrapper"
default['openssh']['server']['authorized_keys_command_run_as'] = "nobody"

default['openssh']['ldap']['uri'] = nil
default['openssh']['ldap']['base'] = nil
default['openssh']['ldap']['timelimit'] = "3"
default['openssh']['ldap']['bind_timelimit'] = "3"
default['openssh']['ldap']['ssl'] = "on"
default['openssh']['ldap']['tls_cacertfile'] = "/etc/ssl/certs/ca-bundle.crt"
