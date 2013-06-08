#
# Author:: Greg Fitzgerald <greg@gregf.org>
# Cookbook Name:: prosody
# Provider:: prosody_user
#
# Copyright 2013, Greg Fitzgerald
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'chef/mixin/shell_out'
require 'chef/mixin/language'
include Chef::Mixin::ShellOut

def whyrun_supported?
  true
end

action :create do
  new_resource.vhosts.each do |vhost|
    Chef::Log.info "Create user #{new_resource.username}@#{vhost}"
    cmd = "prosodyctl register #{new_resource.username} #{vhost} #{new_resource.password}"
    Chef::Log.debug(cmd)
    shell_out!(cmd)
    Chef::Log.info("User created")
  end
  new_resource.updated_by_last_action(true)
end

action :remove do
  new_resource.vhosts.each do |vhost|
    Chef::Log.info "Removing user #{new_resource.username}@#{vhost}"
    cmd = "prosodyctl deluser #{new_resource.username}@#{vhost}"
    Chef::Log.debug(cmd)
    shell_out!(cmd)
    Chef::Log.info("User remove")
  end
  new_resource.updated_by_last_action(true)
end
