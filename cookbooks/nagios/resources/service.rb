#
# Author:: Sean Rettig <seanrettig@gmail.com>
# Cookbook Name:: nagios
# Resource:: service
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

actions :add
default_action :add

attribute :id                   , :kind_of => String, :required => true, :name_attribute => true # Also serves as command_name for the command it generates.
# TODO: Try and put all of these into a loop and add all other possible service and command options. If that's not possible, have one attribute that contains a hash of arbitrary attributes.
attribute :service_description  , :kind_of => String, :default => nil
attribute :host_name            , :kind_of => String, :default => nil
attribute :hostgroup_name       , :kind_of => String, :default => nil
attribute :command_line         , :kind_of => String, :default => nil
