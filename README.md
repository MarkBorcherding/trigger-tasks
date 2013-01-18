# Trigger Tasks

A set of `rake` tasks for working with Trigger.io projects.

## Installation

Add this line to your application's Gemfile (*NOT ON ANY GEM REPO YET*):

    gem 'trigger-tasks'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install trigger-tasks, git@github.com:MarkBorcherding/trigger-tasks.git


Add the following to your `Rakefile`:

```ruby
require 'trigger-tasks'

TriggerTasks.new
```

You can configure the tasks if you wish:


```ruby
require 'trigger-tasks'

TriggerTasks.new do |config|
  config.namespace = 'foo'
end
```

If you want to use the `testflight` task you will need to add some config to the tasks:

```ruby
require 'trigger-tasks'

TriggerTasks.new do |config|
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
TriggerTasks.new do |config|
  config.verbose                # Extra console output default = true
  config.forge_path             # The path to the forge executable. default = 'forge'
  config.namespace              # The namespace of the rake tasks. default = 'forge'
  config.default_platform       # The default platform when running 'rake device'. default = 'ios'

  config.test_flight_api_url    # The url of TestFlight. default = "https://testflightapp.com/api/builds.json"
  config.test_flight_api_token  # Your TestFlight API token. default = ENV['TEST_FLIGHT_API_TOKEN']
  config.test_flight_team_token # Your TestFlight Team Token.
  config.test_flight_distribution_lists # An array of distribution lists in TestFlight.
end

## Usage

Run `rake -T` to see your new tasks.

# Disclaimer

This is still very rough and may not work in all situations.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
