#Prosody Chef Cookbook [![Build Status](https://secure.travis-ci.org/gregf/cookbook-prosody.png)](http://travis-ci.org/gregf/cookbook-prosody)

##Description

The default recipe will install and configure [Prosody](http://prosody.im) xmpp server.

The cookbook also provides a Chef LWRP to manage user accounts and virtualhosts.

* Opscode Community Site: http://community.opscode.com/cookbooks/prosody
* Source Code: http://github.com/gregf/cookbook-prosody

##Requirements

###Chef

Tested on chef 11

###Cookbooks

* [apt](http://community.opscode.com/cookbooks/apt)

###Platforms

* Debian
* Ubuntu

## Recipes

###default

This recipe ensures prosody is installed and configured.

##Attributes
###use_libevent
This will configure prosody to use libevent. Read more [here](http://prosody.im/doc/libevent). May be true of false, defaults to true.

###allow_registration
This will allow public registration for all virtualhosts globally. May be true or false, defaults to false.

###c2s_require_encryption
This will force encryption for client to server connections. May be true or false, defaults to true.

###s2s_secure_auth
If enabled this will require encryption and certificate authentication. Defaults to true.

###s2s_insecure_domains
This is an array of servers that may have self signed certificates or don't support TLS at all (such as gmail.com and all Google-host-domains).  By default this is an empty array.

###s2s_secure_domains
If you choose to not required certificate authentication (s2s_secure_auth), but you want to be sure certain domains are always securely authenticated, you can provide an array or secure domains. This defaults to an empty array.

###package
This is the package that will be installed. It current defaults to the 0.9RC

###authentication
This essentially toggles between plain (default) and hashed passwords. Please read more [here](http://prosody.im/doc/plain_or_hashed). It defaults to plain. 

###storage
This configures the storage method prosody will use to store user accounts, rosters, and offline messages. The default value is internal.

You can read more about storage options [here](http://prosody.im/doc/storage). While there is support for alternative storage methods, the cookbook currently only supports the default internal storage method. Support for sqlite and other methods will come in future updates. Patches welcome.

###libevent_package
This sets the required package when `libevent` is set to true. Defaults to liblua5.1-event0.

###luasec_package
This sets the required package when 's2s_secure_auth` is set to true. Defaults to lua-sec-prosody.

###vhosts_dir
The prosody_vhost lwrp  uses this directory to store individual configuration files for virtualhosts. Defaults to /etc/prosody/vhosts.d.

###pidfile
This sets the default location of the pid file to /var/run/prosody/prosody.pid. This is a required setting for mod_posix, which allows the daemon to detach.



##Resources & Providers

### prosody_vhost
<table>
  <thead>
    <tr>
      <th>Action</th>
      <th>Description</th>
      <th>Default</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>create</td>
      <td>
        Create the virtual host by rendering a template file in <code>/etc/prosody/vhosts.d</code>.
      </td>
      <td>Yes</td>
    </tr>
    <tr>
      <td>remove</td>
      <td>Remove the user virtual host</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>admins</td>
      <td>Add admin users for the virtual host</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>modules_enabled</td>
      <td>Enable a custom set of modules to load for the virtual host</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>enabled</td>
      <td>Enable or Disable the virtual host</td>
      <td>true</td>
    </tr>
  </tbody>
</table>

####Examples

####Creating a Virtual Host

```ruby
prosody_vhost 'redneck.im'
```

####Creating a Virtual Host with Some Options
```ruby
prosody_vhost 'redneck.im' do
  admins: %w[jimbob@redneck.im]
  modules_enabled: %w[dialback roster saslauth]
  enabled true
end
```
#### Remove a Virtual Host
```ruby
prosody_vhost 'redneck.im' do
  action :remove
end
```

### prosody_user

<table>
  <thead>
    <tr>
      <th>Action</th>
      <th>Description</th>
      <th>Default</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>create</td>
      <td>
        Create a user for a virtual host
      </td>
      <td>Yes</td>
    </tr>
    <tr>
      <td>remove</td>
      <td>Remove the user from a virtual host</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>password</td>
      <td>Set a password for the user</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>vhost</td>
      <td>An array or virtualhosts you want to add the user to</td>
      <td>&nbsp;</td>
    </tr>
  </tbody>
</table>

####Examples

#####Creating a User Account

```ruby
prosody_user 'jimbob' do
  password 'gonefishing'
  vhosts %w[redneck.im]
end
```
#####Remove a User Account

```ruby
prosody_user 'jimbob' do
  action :remove
end
```

##Contributing

e.g.

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

##License and Authors

Authors: Greg Fitzgerald <greg@gregf.org>

```
# Copyright 2013, Greg Fitzgerald.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
```
