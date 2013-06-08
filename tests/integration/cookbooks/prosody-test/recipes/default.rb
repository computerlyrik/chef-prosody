#
# Cookbook Name:: prosody-test
# Recipe:: default
#

include_recipe 'prosody'

prosody_vhost 'redneck.im' do
  admins %w[jimbob@redneck.im daryl@redneck.im]
  modules_enabled %w[dialback roster saslauth]
  enabled true
end

prosody_vhost 'example.com' do
  admins %w[root@example.com]
  enabled false
end

prosody_vhost 'flyfisher.com' do
  enabled  true
end

prosody_vhost 'axechat.com'

prosody_user 'jimbob' do
  password 'salmonmaster93'
  vhosts %w[redneck.im]
end

prosody_user 'daryl' do
  password 'bigbuckhunt3r'
  vhosts %w[redneck.im]
end

prosody_user 'otherbrotherdaryl' do
  password 'duckzilla'
  vhosts %w[axechat.com]
end

prosody_user 'otherbrotherdaryl' do
  action :remove
end

prosody_vhost 'flyfisher.com' do
  action :remove
end

