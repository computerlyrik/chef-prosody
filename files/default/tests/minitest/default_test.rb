require 'minitest/spec'
#
## Cookbook Name:: prosody 
## Spec:: default

describe_recipe 'prosody::default' do
  it "ensures prosody is installed" do
    package("prosody-0.9").must_be_installed
  end

  it "ensures a config file is present" do
    file('/etc/prosody/prosody.cfg.lua').must_exist
  end

  it "ensures prosody is running" do
    service("prosody").must_be_running
  end
end
