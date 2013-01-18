require 'hashie'

class Configuration < Hashie::Dash
  property :forge_path, :required => true, :default => 'forge'
  property :namespace, :required => true, :default => 'forge'
  property :default_platform, :default => 'ios'
end
