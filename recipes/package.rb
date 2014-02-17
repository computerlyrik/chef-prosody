
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

package node['prosody']['luasec_package'] if node['prosody']['s2s_secure_auth']
package node['prosody']['libevent_package'] if node['prosody']['use_libevent']

package node['prosody']['package']

include_recipe 'prosody::config'
