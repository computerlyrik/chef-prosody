actions :create, :remove

default_action :create

attribute :username, :kind_of => String, :name_attribute => true
attribute :password, :kind_of => String, :required => true
attribute :vhosts, :kind_of => [Array,String], :required => true, :default => []

