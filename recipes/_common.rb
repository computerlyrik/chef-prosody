user node['prosody']['user'] do
  system true
  comment 'Prosody XMPP Server'
  home '/var/lib/prosody'
  shell '/bin/false'
  manage_home true
  action :create
end

directory "/var/log/prosody" do
  owner "root"
  group node['prosody']['group']
  mode "0755"
end
