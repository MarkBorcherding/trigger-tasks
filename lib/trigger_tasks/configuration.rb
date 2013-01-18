require 'hashie'

class Configuration < Hashie::Dash
  property :namespace, :required => true, :default => 'forge'
end
