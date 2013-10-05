#
# Author:: Sean Rettig <seanrettig@gmail.com>
# Cookbook Name:: nagios
# Provider:: service
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

# Support whyrun.
def whyrun_supported?
  true
end

action :add do
  Chef::Log.info "Adding #{new_resource.id} to #{node['nagios']['config_dir']}/services.cfg"
  Chef::Log.info "Adding #{new_resource.check_command} to #{node['nagios']['config_dir']}/commands.cfg"

  new_service = Hash.new
  
  new_service['id'] = new_resource.id
  # TODO: Convert all these if statements to a loop somehow?
  if(new_resource.service_description)
    new_service['service_description'] = new_resource.service_description
  end
  if(new_resource.host_name)
    new_service['host_name'] = new_resource.host_name
  end
  if(new_resource.hostgroup_name)
    new_service['hostgroup_name'] = new_resource.hostgroup_name
  end
  if(new_resource.command_line)
    new_service['command_line'] = new_resource.command_line
  end

  @services << new_service # Add the new service/command to the array of services/commands to be created in the services.cfg/commands.cfg templates.
end
