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

def load_current_resource
  @username = new_resource.username
  @password = new_resource.password
  @vhosts = new_resource.vhosts
end

action :create do
  @vhosts.each do |vhost|
    Chef::Log.info "Create user #{@username}@#{vhost}"
    cmdStr = "prosodyctl register #{@username}"
    cmdStr << " #{vhost} #{@password}"
    cmd = Mixlib::ShellOut.new(cmdStr)
    cmd.run_command
    Chef::Log.debug("Create user? #{cmdStr}")
    Chef::Log.debug("Create user?? #{cmd.stdout}")
    cmd.error!
  end
  new_resource.updated_by_last_action(true)
end

action :remove do
  @vhosts.each do |vhost|
    Chef::Log.info "Removing user #{@username}@#{vhost}"
    cmdStr = "prosodyctl deluser #{@username}@#{vhost}"
    cmd = Mixlib::ShellOut.new(cmdStr)
    cmd.run_command
    Chef::Log.debug("Remove user? #{cmdStr}")
    Chef::Log.debug("Remove user?? #{cmd.stdout}")
    cmd.error!
  end
  new_resource.updated_by_last_action(true)
end
