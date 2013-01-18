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

## Usage

Run `rake -T` to see your new tasks.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
