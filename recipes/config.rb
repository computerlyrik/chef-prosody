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
    :plugin_paths => node['prosody']['plugin_paths'],
    :ldap_server => (ldap_server if ldap)
  )
  notifies :restart, "service[prosody]"
end
