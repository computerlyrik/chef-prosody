include_recipe "prosody::_common"

package node['prosody']['luasec_package'] if node['prosody']['s2s_secure_auth']
package node['prosody']['libevent_package'] if node['prosody']['use_libevent']

package node['prosody']['package']

include_recipe 'prosody::config'
