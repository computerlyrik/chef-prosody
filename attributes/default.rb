default['prosody']['install_tpye'] = "package" #source


if node['prosody']['install_tpye'] == "package"
  default['prosody']['module_dir'] = "/usr/lib/prosody/modules"
  default['prosody']['conf_dir'] = "/etc/prosody"
  default['prosody']['cert_dir'] = "/etc/prosody/certs"
elsif node['prosody']['install_tpye'] == "source"
  default['prosody']['src_dir'] = "/prosody"
  default['prosody']['module_dir'] = "#{node['prosody']['src_dir']}/plugins"
  default['prosody']['conf_dir'] = "#{node['prosody']['src_dir']}"
  default['prosody']['cert_dir'] = "#{node['prosody']['src_dir']}/certs"
end


default['prosody']['auth'] = "ldap" #internal_plain
