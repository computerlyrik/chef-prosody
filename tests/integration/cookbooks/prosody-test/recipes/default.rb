#
# Cookbook Name:: prosody-test
# Recipe:: default
#

include_recipe 'prosody'

prosody_vhost 'redneck.im' do
  admins ['jimbob@redneck.im', 'daryl@redneck.im']
  modules_enabled ['dialback', 'roster', 'saslauth']
  enabled true
end

prosody_vhost 'example.com' do
  admins ["root@example.com"]
  enabled false
end

prosody_vhost 'flyfisher.com' do
  enabled  true
end

prosody_vhost 'axechat.com'

prosody_user 'jimbob' do
  password 'salmonmaster93'
  vhosts "redneck.im"
end

prosody_user 'daryl' do
  password  'bigbuckhunt3r'
  vhosts "redneck.im"
end

prosody_user 'otherbrotherdaryl' do
  password 'duckzilla'
  vhosts ["redneck.im", "axechat.com"]
end

prosody_user 'otherbrotherdaryl' do
  action :remove
end

prosody_vhost 'flyfisher.com' do
  action :remove
end


prosody_module "roster" do 
  action [:install, :enable]
end

prosody_module "saslauth" do
  action [:install, :enable]
end
