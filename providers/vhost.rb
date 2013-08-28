#
# Author:: Greg Fitzgerald <greg@gregf.org>
# Cookbook Name:: prosody
# Provider:: prosody_vhost
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

include Chef::Prosody::Helpers

def whyrun_supported?
  true
end

action :create do
  Chef::Log.info "Adding #{new_resource.vhost} to #{node['prosody']['vhosts_dir']}"
  template vhost_config_file do
    source "vhost.cfg.lua.erb"
    cookbook "prosody"
    owner "root"
    group "root"
    mode "0644"
    variables({
      'config' => {
        'vhost' => new_resource.vhost,
        'admins' => new_resource.admins,
        'modules_enabled' => new_resource.modules_enabled,
        'enabled' => new_resource.enabled,
        'ssl' => new_resource.ssl
      }
    })
    generate_ssl if new_resource.ssl
    notifies :reload, "service[prosody]"
  end
  new_resource.updated_by_last_action(true)
end

action :remove do
  if ::File.exists?("#{node['prosody']['vhosts_dir']}/#{new_resource.vhost}.cfg.lua")
    Chef::Log.info "Removing #{new_resource.vhost} from #{node['prosody']['vhosts_dir']}"
    file vhost_config_file do
      action :delete
      notifies :reload, "service[prosody]"
    end
   remove_ssl
   new_resource.updated_by_last_action(true)
  end
end
