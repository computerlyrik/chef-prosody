include_recipe 'apt'

# add the prosody repo; grab key from keyserver
case node["prosody"]["repository"]
when "debian", "ubuntu"
  include_recipe "apt"
  apt_repository "prosody" do
    uri "http://packages.prosody.im/debian"
    distribution node['lsb']['codename']
    components ["main"]
    key "http://prosody.im/files/prosody-debian-packages.key"
  end
when "epel"
  include_recipe "yum::epel"
end



if node['prosody']['s2s_secure_auth'] then
  package node['prosody']['luasec_package']
end

if node['prosody']['use_libevent'] then
  package node['prosody']['libevent_package']
end

package node['prosody']['package']


include_recipe 'prosody::config'
