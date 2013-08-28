#
# Author:: Greg Fitzgerald <greg@gregf.org>
# Cookbook Name:: prosody
# Library:: default
#
# Copyright 2013, Greg Fitzgerald
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

require 'mixlib/shellout'

class Chef
  module Prosody
    module Helpers
      def generate_ssl
        unless File.exist?("#{cert_name}.crt") && File.exist?("#{cert_name}.key")
          Chef::Log.info "Generating vhost for #{vhost}"
          cmd = Mixlib::ShellOut.new(ssl_cmd)
          cmd.run_command
          Chef::Log.debug("openssl command? #{ssl_cmd}")
          Chef::Log.debug("openssl command? #{cmd.stdout}")
          cmd.error!
        end
      end

      def ssl_cmd
        cmd = "openssl req -new -x509 -days 3650 -nodes -sha1 -subj #{subj} "
        cmd << " -out #{cert_name}.crt -newkey rsa:2048 -keyout #{cert_name}.key"
      end

      def remove_ssl
        Chef::Log.info "Removing any existing certs for #{vhost}"
        ::File.delete "#{cert_name}.crt" if ::File.exists?("#{cert_name}.crt")
        ::File.delete "#{cert_name}.key" if ::File.exists?("#{cert_name}.key")
      end

      def vhost
        new_resource.vhost
      end

      def vhost_config_file
        ::File.join(node['prosody']['vhosts_dir'], "#{vhost}.cfg.lua")
      end

      def cert_name
        ::File.join(node['prosody']['ssl_dir'], vhost)
      end

      def subj
        subj = "/C=#{node['ssl']['country']}/ST=#{node['ssl']['state']}"
        subj << "/L=#{node['ssl']['city']}/O=#{vhost}/OU=#{vhost}"
        subj << "/CN=#{vhost}/emailAddress=root@#{vhost}"
      end
    end
  end
end
