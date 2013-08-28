name             'prosody'
maintainer       "Greg Fitzgerald, computerlyrik"
maintainer_email "chef-cookbooks@computerlyrik.de, greg@gregf.org"
license          "Apache 2.0"
description      "Installs/Configures prosody"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.2.0"
depends           "mercurial"
supports          "ubuntu","12.10"

recipe 'prosody', 'Installs sudo and configures prosody'

%w{ apt }.each do |dep|
  depends dep
end

%w{ debian ubuntu centos fedora }.each do |os|
  supports os
end
