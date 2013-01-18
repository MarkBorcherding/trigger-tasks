require 'hashie'

class Configuration < Hashie::Dash
  property :verbose, :required => true, :default => true

  property :forge_path, :required => true, :default => 'forge'
  property :namespace, :required => true, :default => 'forge'
  property :default_platform, :default => 'ios'

  property :test_flight_api_url, :default => "https://testflightapp.com/api/builds.json"
  property :test_flight_api_token, :default => ENV['TEST_FLIGHT_API_TOKEN']
  property :test_flight_team_token
  property :test_flight_distribution_lists
end
