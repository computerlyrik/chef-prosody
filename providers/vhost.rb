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

def whyrun_supported?
  true
end

action :create do
  converge_by ("Adding #{new_resource.vhost} to #{node['prosody']['vhosts_dir']}") do
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
      notifies :reload, "service[prosody]", :immediately
    end

    execute "Generating vhost certs for #{vhost}" do
      command ssl_cmd
      only_if { new_resource.ssl }
      not_if { ::File.exists?("#{cert_name}.crt") && ::File.exists?("#{cert_name}.key") }
    end
  end
  new_resource.updated_by_last_action(true)
end

action :remove do
  if @current_resource.exists
    converge_by "Removing #{@current_resource.vhost} from #{node['prosody']['vhosts_dir']}" do
      file vhost_config_file do
        action :delete
        notifies :reload, "service[prosody]"
      end
      ["#{cert_name}.crt", "#{cert_name}.key"].each do |f|
        file f do
          action :delete
        end
      end
    end
    new_resource.updated_by_last_action(true)
  else
    Chef::Log.info "#{ @current_resource } doesn't exist - can't delete."
  end
end

def load_current_resource
  @current_resource = Chef::Resource::ProsodyVhost.new(@new_resource.name)
  @current_resource.name(@new_resource.name)
  @current_resource.vhost(@new_resource.vhost) 
  @current_resource.exists = true if vhost_exist?(@current_resource.vhost)
end

def ssl_cmd
  cmd = "openssl req -new -x509 -days 3650 -nodes -sha1 -subj #{subj} "
  cmd << " -out #{cert_name}.crt -newkey rsa:2048 -keyout #{cert_name}.key"
end

def vhost
  @current_resource.vhost
end

def vhost_config_file(vhostname = vhost)
  ::File.join(node['prosody']['vhosts_dir'], "#{vhostname}.cfg.lua")
end

def cert_name
  ::File.join(node['prosody']['ssl_dir'], vhost)
end

def subj
  subj = "/C=#{node['ssl']['country']}/ST=#{node['ssl']['state']}"
  subj << "/L=#{node['ssl']['city']}/O=#{vhost}/OU=#{vhost}"
  subj << "/CN=#{vhost}/emailAddress=root@#{vhost}"
end

def vhost_exist?(vhost)
  ::File.exists?(vhost_config_file(vhost))
end
