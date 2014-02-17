actions :create, :remove

default_action :create

# The fqdn of the virtualhost
attribute :vhost, :kind_of => String, :name_attribute => true
attribute :admins, :kind_of => Array, :required => false, :default => []
attribute :modules_enabled, :kind_of => Array, :required => false, :default => []
attribute :enabled, :kind_of => [TrueClass, FalseClass], :default => true
attribute :ssl, :kind_of => [TrueClass, FalseClass], :default => true
attribute :muc, :kind_of => String
attr_accessor :exists
