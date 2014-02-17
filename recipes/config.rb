include_recipe "prosody::service"

directory node['prosody']['conf_d_dir'] do
  owner "root"
  group node["prosody"]["group"]
  mode "0750"
end

node['prosody']['plugin_paths'].each do |dir|
  directory dir do
    owner "root"
    group node["prosody"]["group"]
    mode "0750"
    recursive true
  end
end

directory node['prosody']['vhosts_dir'] do
  owner "root"
  group "prosody"
  mode "0750"
  action :create
end

directory node['prosody']['ssl_dir'] do
  owner "root"
  group "prosody"
  mode "0750"
  action :create
end

include_recipe "prosody::ldap" if node['prosody']['authentication'] == "ldap"

prosody_module "listusers" do
  files("mod_listusers.lua" => "http://prosody.im/files/mod_listusers.lua")
  action :install
end

template ::File.join(node['prosody']['conf_dir'], "prosody.cfg.lua") do
  source "prosody.cfg.lua.erb"
  owner "root"
  group node["prosody"]["group"]
  mode "0750"
  variables(
    :admins => node['prosody']['admins'],
    :modules_enabled => node['prosody']['modules_enabled'],
    :modules_disabled => node['prosody']['modules_disabled'],
    :authentication => node['prosody']['authentication'],
    :use_libevent => node['prosody']['use_libevent'],
    :pidfile => node['prosody']['pidfile'],
    :daemonize => node['prosody']['daemonize'],
    :plugin_paths => node['prosody']['plugin_paths']
  )
  notifies :restart, "service[prosody]"
end
