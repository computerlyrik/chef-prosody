template "prosody init" do
  path "/etc/init.d/prosody"
  source "prosody.init.erb"
  owner "root"
  group "root"
  mode "755"
  notifies :restart, "service[prosody]"
  action :create_if_missing
end

service "prosody" do
  supports :status => true, :restart => true, :reload => true
  action [:enable]
end
