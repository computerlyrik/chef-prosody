case node['prosody']['lua-zlib']['install_type']
when 'source'
  ark "lua-zlib" do
    url "https://github.com/brimworks/lua-zlib/archive/v0.2.tar.gz" # TODO: attribute
    version "0.2"
    action :install
    not_if "lua -e \"require 'zlib'\""
    notifies :run, 'bash[install-lua-zlib]', :immediately
  end

  bash "install-lua-zlib" do
    code <<-EOH
      make linux
      if [ -d /usr/lib64 ] ; then cp zlib.so /usr/lib64/lua/5.1
      else cp zlib.so /usr/lib/lua/5.1'; fi
    EOH
    cwd "/usr/local/lua-zlib"
    action :nothing
  end
when 'package'
  package 'lua-zlib'
end
