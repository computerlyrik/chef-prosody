include_recipe "ark"

ark "prosody" do
  url "http://prosody.im/downloads/source/prosody-#{node["prosody"]["source"]["version"]}.tar.gz"
  version node["prosody"]["source"]["version"]
  action :install
  notifies :restart, "service[prosody]"
end



directory "/var/log/prosody/"


include_recipe "prosody::config"

