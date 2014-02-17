#
# Cookbook Name:: prosody
# Attributes:: default
#
# Copyright 2013, Greg Fitzgerald.
# Copyright 2013, Christian Fischer, computerlyrik.
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

case node['platform_family']
when 'debian', 'ubuntu'
  default['prosody']['install_type'] = 'package'
else
  default['prosody']['install_type'] = 'source'
end

case node['prosody']['install_type']
when "package"
  default['prosody']['package'] = "prosody"
  default['prosody']['luasec_package'] = 'lua-sec-prosody'
  default['prosody']['libevent_package'] = value_for_platform(
    'debian' => { 'default' => 'lua-event' },
    'ubuntu' => { ['10.04', '10.10', '11.04', '11.10'] => 'liblua5.1-event0' },
    'default' => 'lua-event'
  )
when "source"
  default['prosody']['version'] = '0.9.1'
  case node['platform_family']
  when 'debian'
    default['prosody']['source_packages'] = %w{lua5.1 liblua5.1-dev liblua5.1-event0 libssl-dev libidn11-dev lua5.1-filesystem lua5.1-expat lua5.1-dbi-mysql}
  else
    default['prosody']['source_packages'] = %w{lua lua-devel lua-event openssl-devel libidn-devel lua-filesystem lua-expat lua-dbi}
  end
  default['prosody']['runtime'] = '/usr/bin/lua'
  default['prosody']['daemon'] = '/usr/bin/prosody'
  default['prosody']['source']['origin'] = "web" # mercurial
  default['prosody']['base_url'] = 'http://prosody.im/downloads/source/'
  default['prosody']['sha256'] = '6cdea6fd6027bec621f7995709ca825a29aa5e066b321bfbb7785925c9f32cd5'
end

default['prosody']['plugin_dir'] = "/usr/local/lib/prosody/modules"
default['prosody']['conf_dir'] = "/etc/prosody"
default['prosody']['run_dir'] = '/var/run/prosody/'
default['prosody']['bin_path'] = '/usr/bin'
default['prosody']['vhosts_dir'] = ::File.join(node['prosody']['conf_dir'], 'vhosts.d')
default['prosody']['conf_d_dir'] = ::File.join(node['prosody']['conf_dir'], 'conf.d')
default['prosody']['plugin_paths'] = [node['prosody']['plugin_dir']] # http://prosody.im/doc/installing_modules
default['prosody']['ssl_dir'] = ::File.join(node['prosody']['conf_dir'], 'certs')

default['prosody']['pidfile'] = ::File.join(node['prosody']['run_dir'], 'prosody.pid')

default['prosody']['user'] = 'prosody'
default['prosody']['group'] = 'prosody'
default['prosody']['storage'] = 'internal'
default['prosody']['authentication'] = 'internal_plain' # ldap
default['prosody']['use_libevent'] = true
default['prosody']['allow_registration'] = false

default['prosody']['c2s_require_encryption'] = true
default['prosody']['s2s_secure_auth'] = true
default['prosody']['s2s_insecure_domains'] = []
default['prosody']['s2s_secure_domains'] = []

default['prosody']['daemonize'] = true

default['prosody']['catchall'] = nil

default['prosody']['admins'] = ['admin']
default['prosody']['modules_disabled'] = []
# For more information http://prosody.im/doc/modules_enabled
default['prosody']['modules_enabled'] = %w( roster saslauth tls dialback disco
                                            private vcard version uptime time
                                            ping pep register admin_adhoc posix)

# Rest of the -subj values are defaulted to your vhost
default['ssl']['country'] = 'NL'
default['ssl']['state'] = 'NH'
default['ssl']['city'] = 'AMS'
