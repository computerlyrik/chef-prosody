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

include_recipe "prosody::_common"

node.set['build_essential']['compiletime'] = true
include_recipe 'build-essential'

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

  source_path = ::File.join(Chef::Config[:file_cache_path], "prosody-#{node['prosody']['version']}")
  directory source_path do
    owner node['prosody']['user']
    group node['prosody']['group']
    recursive true
  end

  configure_opts = ""
  case node['prosody']['source']['origin']
  when "web"
    ark "prosody" do
      path source_path
      checksum node['prosody']['sha256']
      url "#{node['prosody']['base_url']}/prosody-#{node["prosody"]["version"]}.tar.gz"
      owner node['prosody']['user']
    end
  when "mercurial"
    include_recipe 'mercurial'
    mercurial source_path do
      repository "http://hg.prosody.im/0.9"
      action :clone
      owner node['prosody']['user']
      group node['prosody']['group']
    end
    configure_opts += " --ostype=debian"
  end

  execute "install-prosody" do
    command "./configure" + configure_opts + " --prefix=/usr --sysconfdir=#{node['prosody']['conf_dir']} && make install clean"
    cwd source_path
  end
end

include_recipe "prosody::config"
