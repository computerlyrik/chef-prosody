name             'prosody'
maintainer       "Greg Fitzgerald, computerlyrik"
maintainer_email "greg@gregf.org, chef-cookbooks@computerlyrik.de"
license          "Apache 2.0"
description      "Installs/Configures prosody"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.5.1"

recipe           'prosody', 'Installs sudo and configures prosody'

depends          "apt"
depends          "yum"
depends          "mercurial"
depends          "ark"
depends          "build-essential"

supports         "debian"
supports         "ubuntu"
supports         "centos"
supports         "fedora"
