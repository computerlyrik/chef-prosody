actions :add, :install, :delete, :enable, :disable
default_action :add

attribute :module, :name_attribute => true, :kind_of => String, :required => true, :name_attribute => true
attribute :files, :kind_of => Hash, :default => Hash.new

attr_accessor :configured
