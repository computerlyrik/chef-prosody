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

#use_inline_resources

def whyrun_supported?
  true
end

def load_current_resource
  @current_resource = Chef::Resource::ProsodyUser.new(@new_resource.name)
  @current_resource.name(@new_resource.name)
  @current_resource.username(@new_resource.username)
  @current_resource.password(@new_resource.password)
  @current_resource.vhosts(Array(@new_resource.vhosts))
end

action :create do
  @current_resource.vhosts.each do |vhost|
    execute "Create user #{jid(vhost)}" do
      command "prosodyctl register #{current_resource.username} #{vhost} #{current_resource.password}"
      not_if { jid_exists?(jid(vhost)) }
    end
  end
end

action :remove do
  @current_resource.vhosts.each do |vhost|
    execute "Removing user #{jid(vhost)}" do
      command "prosodyctl deluser #{jid(vhost)}"
      only_if { jid_exists?(jid(vhost)) }
    end
  end
end

def jids
  return @current_resource.vhost.map {|v| jid(v,new_resource.username)}
end

def jid(domain, username = current_resource.username)
  return username + "@" + domain
end

def jid_exists?(jid)
  Mixlib::ShellOut.new("prosodyctl mod_listusers").run_command.stdout.split.include?(jid)
end
