#
# Cookbook Name:: prosody
# Recipe:: default
#
# Copyright 2012, computerlyrik
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'mercurial'

hg node['prosody']['src_dir'] do
  repository "http://hg.prosody.im/0.9"
  action :sync
end


%w{lua5.1 liblua5.1-dev libidn11-dev libssl-dev}.each do |pkg|
  package pkg
end


execute "./configure --ostype=debian" do
  cwd node['prosody']['scr_dir']
  action :nothing
  subscribes :run, resources(:hg => node['prosody']['src_dir'])
  notifies :run, resources(:execute => "make")
end

execute "make" do
  cwd node['prosody']['scr_dir']
  action :nothing
end

%w{liblua5.1-socket2 liblua5.1-expat0 liblua5.1-filesystem0 liblua5.1-sec1}.each do |pkg|
  package pkg
end

directory "/var/log/prosody/"

ruby_block "default" do
  block do
    include_recipe "prosody"
  end
end
