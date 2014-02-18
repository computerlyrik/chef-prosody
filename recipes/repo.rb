case node["platform_family"]
when "debian", "ubuntu"
  include_recipe 'apt'
  apt_repository "prosody" do
    uri "http://packages.prosody.im/debian"
    distribution node['lsb']['codename']
    components ["main"]
    key "http://prosody.im/files/prosody-debian-packages.key"
  end
when "epel"
  include_recipe "yum::epel"
end
