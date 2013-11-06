#
# Cookbook Name:: prosody
# Recipe:: ldap
#
# Copyright 2013, Greg Fitzgerald
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
unless Chef::Config[:solo]
  Chef::Log.warn("This recipe uses search. Chef Solo does not support search.")
  return
end

Chef::Log.info "preparing for ldap"
package "lua-ldap"
 
template ::File.join(node['prosody']['module_dir'], "mod_auth_ldap.lua") do
  mode 0644
  notifies :restart, "service[prosody]"
end

template ::File.join(node['prosody']['conf_d_dir'], "auth_ldap.cfg.lua") do
  mode 0644
  variables(
    :ldap_server => search(:node, "recipes:openldap\\:\\:users && domain:#{node['domain']}").first
  )
  notifies :restart, "service[prosody]"
end
