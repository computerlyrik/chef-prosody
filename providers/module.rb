action :enable do
  ruby_block "Configure module #{new_resource.module}" do
    block do
      node.override['prosody']['modules_enabled'] = node['prosody']['modules_enabled'] + [ new_resource.module ]
      node.override['prosody']['modules_disabled'] = node['prosody']['modules_disabled'] - [ new_resource.module ]
      node.save
    end
    notifies :create, "template[#{node['prosody']['conf_dir']}/prosody.cfg.lua]"
    not_if { current_resource.configured }
  end
end

action :install do
  install_files
end

action :disable do
  ruby_block "Unconfigure module #{new_resource.module}" do
    block do
      node.override['prosody']['modules_enabled'] = node['prosody']['modules_enabled'] - [ new_resource.module ]
      node.override['prosody']['modules_disabled'] = node['prosody']['modules_disabled'] - [ new_resource.module ]
      node.save
    end
    only_if { current_resource.configured }
  end
end

def load_current_resource
  @current_resource = Chef::Resource::ProsodyModule.new(@new_resource.name)
  @current_resource.module(@new_resource.module)
  @current_resource.configured = true if module_configured?(@new_resource.module)
end

def module_configured?(name)
  node['prosody']['modules_enabled'].include?(name) && !node['prosody']['modules_disabled'].include?(name)
end

def local_path(file)
  return ::File.join(node['prosody']['chef_plugin_path'], "mod_#{new_resource.module}", file)
end

def install_files
  new_resource.files.each do |file, uri|
    directory ::File.dirname(local_path(file)) do
      owner "root"
      group node['prosody']['group']
      mode "0754"
    end

    remote_file local_path(file) do
      source uri
      owner "root"
      group node['prosody']['group']
      mode "0754"
      notifies :restart, "service[prosody]"
    end
  end
end
