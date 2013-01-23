# Trigger Tasks

A set of `rake` tasks for working with Trigger.io projects.

## Installation

Add this line to your application's Gemfile (*NOT ON ANY GEM REPO YET*):

    gem 'trigger-tasks', :git => 'git@github.com:MarkBorcherding/trigger-tasks.git'

And then execute:

    $ bundle

Add the following to your `Rakefile`:

```ruby
require 'trigger-tasks'

TriggerTasks.new
```

You can configure the tasks if you wish:


```ruby
require 'trigger-tasks'

TriggerTasks::TaskLib.new do |config|
  config.namespace = 'foo'
end
```

If you want to use the `testflight` task you will need to add some config to the tasks:

```ruby
require 'trigger-tasks'

TriggerTasks::TaskLib.new do |config|
  config.test_flight_team_token = '<< your team token >>'
  config.test_flight_distribution_lists = ['your', 'distribution', 'lists']
end
```

Also, you will need to create an environment variable `TEST_FLIGHT_API_TOKEN` with your
api token. Eventually it would be nice to have a `.test_flight_api_key` file that is added
to the `.gitignore` to avoid mucking with the environment.

## Config

There are several options that can be configured in the setup block.

```ruby
TriggerTasks::TaskLib.new do |config|
  config.verbose                # Extra console output default = true
  config.forge_path             # The path to the forge executable. default = 'forge'
  config.namespace              # The namespace of the rake tasks. default = 'forge'
  config.default_platform       # The default platform when running 'rake device'. default = 'ios'
  config.build_task             # The rake task to invoke before forge builds. (Optional)

  config.test_flight_api_url    # The url of TestFlight. default = "https://testflightapp.com/api/builds.json"
  config.test_flight_api_token  # Your TestFlight API token. default = ENV['TEST_FLIGHT_API_TOKEN']
  config.test_flight_team_token # Your TestFlight Team Token.
  config.test_flight_distribution_lists # An array of distribution lists in TestFlight.
end
```

## Usage

Run `rake -T` to see your new tasks.

```
rake device                          # Open the app in the device
rake forge                           # Open the app in the iOS simulator
rake forge:ios                       # Open the app in the iOS simulator
rake forge:ios:build                 # Build the app for iOS
rake forge:ios:device                # Run the app on the device
rake forge:ios:package               # Package the app for iOS deveployment in the simulator or device
rake forge:ios:run                   # Run the app in the location specified in the local_config.json
rake forge:ios:run:device            # Run the app in the simulator
rake forge:ios:run:simulator         # Run the device on the device
rake forge:ios:run:simulator:ipad    # Force the app to run in the iPad simulator
rake forge:ios:run:simulator:iphone  # Force the app to run in the iPhone simulator
rake simlator                        # Open the app in the simulator
rake testflight                      # Deploy to TestFlight
```

# Disclaimer

This is still very rough and may not work in all situations.

# TODO

* Allow passing TestFlight parameters on the command line to hook it entirely into the automated build process
* Get other platforms' commands. (e.g. Android, web, Windows)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
