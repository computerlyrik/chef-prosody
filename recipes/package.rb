#
# Cookbook Name:: prosody
# Recipe:: package
#
# Copyright 2012, computerlyrik
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

include_recipe 'apt'

# add the prosody repo; grab key from keyserver
apt_repository "prosody.im" do
  uri "http://packages.prosody.im/debian"
  distribution node['lsb']['codename']
  components ["main"]
  key "http://prosody.im/files/prosody-debian-packages.key"
end

if node['prosody']['s2s_secure_auth'] then
  package node['prosody']['luasec_package']
end

if node['prosody']['use_libevent'] then
  package node['prosody']['libevent_package']
end

package node['prosody']['package']

directory node['prosody']['vhosts_dir'] do
    owner "root"
    group "root"
    mode "0755"
    action :create
end


ldap =  node['prosody']['auth']=="ldap"

if ldap
  package "lua-ldap"
  #install or compile lualdap
  #to compile packages: liblua5.1-dev libldap-dev
  
  template "#{node['prosody']['module_dir']}/mod_auth_ldap.lua" do
    mode 0644
    notifies :restart, resources(:service => "prosody")
  end
  ldap_server = search(:node, "recipes:openldap\\:\\:users && domain:#{node['domain']}").first
end

template "#{node['prosody']['conf_dir']}/prosody.cfg.lua" do
  source "prosody.cfg.lua.erb"
  owner "root"
  group "root"
  mode "0644"
  if ldap
    variables ({:ldap_server => ldap_server})
  end
  notifies :restart, resources(:service => "prosody")
end

service "prosody" do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
  subscribes :reload, resources("template[#{node['prosody']['conf_dir']}/prosody.cfg.lua]"), :immediately
end

