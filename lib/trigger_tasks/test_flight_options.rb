require 'hashie'

class TestFlightOptions < Hashie::Dash
  [ :api_token,
    :team_token,
    :file,
    :notes,
    :distribution_lists,
    :notify,
    :replace ].each do |prop|
      property prop
    end
end
