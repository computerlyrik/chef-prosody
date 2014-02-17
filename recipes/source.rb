#
# Cookbook Name:: prosody
# Recipe:: package
#
# Copyright 2013, Greg Fitzgerald
# Copyright 2012, computerlyrik
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
#

node.set['build_essential']['compiletime'] = true
include_recipe 'build-essential'

user node['prosody']['user'] do
  system true
  comment 'Prosody XMPP Server'
  home '/var/lib/prosody'
  shell '/bin/false'
  action :create
end

directory node['prosody']['run_dir'] do
  mode 0755
  owner 'root'
  group node['prosody']['group']
end

unless FileTest.exists?(File.join(node['prosody']['bin_path'], "prosody"))
  require 'digest'

  node['prosody']['source_packages'].each do |pkg|
    package pkg do
      action :install
    end
  end

  link "/usr/include/lua.h" do
    to "/usr/include/lua5.1/lua.h"
  end

  configure_opts = ""
  case node['prosody']['source']['origin']
  when "web"
    remote_file "prosody" do
      path "#{Chef::Config[:file_cache_path]}/prosody.tar.gz"
      checksum node['prosody']['sha256']
      source "#{node['prosody']['base_url']}/prosody-#{node["prosody"]["version"]}.tar.gz"
    end

    execute "extract-prosody" do
      command "cd #{Chef::Config[:file_cache_path]} && tar -xvf prosody.tar.gz"
      creates "#{Chef::Config[:file_cache_path]}/prosody-#{node['prosody']['version']}"
      only_if { Digest::SHA256.file(File.join(Chef::Config[:file_cache_path], 'prosody.tar.gz')).hexdigest == node['prosody']['sha256'] }
    end
  when "mercurial"
    include_recipe 'mercurial'
    mercurial "#{Chef::Config[:file_cache_path]}/prosody-#{node['prosody']['version']}" do
      repository "http://hg.prosody.im/0.9"
      action :clone
      owner node['prosody']['user']
      group node['prosody']['group']
    end
    configure_opts += " --ostype=debian"
  end

  execute "install-prosody" do
    command "cd #{Chef::Config[:file_cache_path]}/prosody-#{node['prosody']['version']} && ./configure" + configure_opts + " --prefix=/usr --sysconfdir=#{node['prosody']['conf_dir']} && make install clean"
  end
end

unless system(%q{lua -e "require 'zlib'"})
  remote_file "lua-zlib" do
    path "#{Chef::Config[:file_cache_path]}/lua-zlib-0.2.tar.gz"
    source "https://github.com/brimworks/lua-zlib/archive/v0.2.tar.gz"
  end

  execute "extract-lua-zlib" do
    command "cd #{Chef::Config[:file_cache_path]} && tar -xvf lua-zlib-0.2.tar.gz"
    creates "#{Chef::Config[:file_cache_path]}/lua-zlib-0.2"
  end

  execute "install-lua-zlib" do
    command "cd #{Chef::Config[:file_cache_path]}/lua-zlib-0.2 && make linux && [[ -d /usr/lib64 ]] && cp zlib.so /usr/lib64/lua/5.1 || cp zlib.so /usr/lib/lua/5.1"
  end
end

directory "/var/log/prosody" do
  owner "root"
  group node['prosody']['group']
  mode "0755"
end

include_recipe "prosody::config"
