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

service "prosody"

template "#{node['prosody']['module_dir']}/mod_auth_ldap.lua" do
  mode 0644
  notifies :restart, resources(:service => "prosody")
end

if node['prosody']['auth']=="ldap"
  package "lua-ldap"
  
  #install or compile lualdap
  #to compile packages: liblua5.1-dev libldap-dev
end
ldap_server = search(:node, "recipes:openldap\\:\\:users && domain:#{node['domain']}").first

template "#{node['prosody']['conf_dir']}/prosody.cfg.lua" do
  notifies :restart, resources(:service => "prosody")
  variables ({:ldap_server => ldap_server})
end

