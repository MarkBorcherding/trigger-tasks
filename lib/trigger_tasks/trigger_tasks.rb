require 'rake/tasklib'
require 'highline/import'

require 'trigger_tasks/configuration'
require 'trigger_tasks/test_flight_options'

class TriggerTasks < ::Rake::TaskLib


  def initialize
    @config = Configuration.new
    yield @config if block_given?
    define_tasks
  end


  private

  def forge args
    sh "#{config.forge_path} #{args}"
  end

  def tasks_namespace
    @config.namespace
  end

  def most_recent_ios_ipa
    ""
  end

  def push_to_testflight options
    options.api_token = @config.test_flight_api_token
    options.team_token = @config.test_flight_team_token
    options.file = most_recent_ios_ipa
  end

  def to_bool s
    return true   if s == true   || s =~ (/(true|t|yes|y|1)$/i)
    return false  if s == false  || s =~ (/(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end

  def agree prompt, default
    ask(prompt, lambda { |a| to_bool a }) do |q|
      q.default = default
    end
  end

  def test_flight_tasks
    desc 'Deploy to TestFlight'
    task :testflight do

      release_notes = ask 'Enter release notes: '

      # TODO Allow multi select here.
      distribution_lists = @config.test_flight_distribution_lists
      selected_lists = []
      choose do |menu|
        menu.index        = :letter
        menu.index_suffix = ") "
        menu.header = "Build Permissions"
        menu.prompt = "Select distribution lists: "
        menu.choices *distribution_lists do |list|
          selected_lists << list
        end
        menu.hidden "", "none" do
        end
      end if distribution_lists

      notify_users = agree 'Notify Users? ', 'yes'
      replace = agree "Replace existing version? ", 'no'

      push_to_testflight TestFlightOptions.new :notes => release_notes,
        :distribution_lists => distribution_lists,
        :notify => notify_users

    end
  end


  def default_platform_tasks
    platform = @config.default_platform
    desc 'Open the app in the device'
    task :device => "#{tasks_namespace}:#{platform}:device"

    desc 'Open the app in the simulator'
    task :simlator => "#{tasks_namespace}:#{platform}:simulator"

    desc 'Open the app in the iOS simulator'
    task tasks_namespace => "#{tasks_namespace}:#{platform}"
  end

  def define_tasks

    test_flight_tasks if @config.test_flight_api_token
    default_platform_tasks if @config.default_platform

    namespace tasks_namespace do

      desc 'Open the app in the iOS simulator'
      task :ios  => %W{ #{tasks_namespace}:ios:run }

      namespace :ios do

        desc 'Run the app on the device'
        task :device  => %W{ #{tasks_namespace}:ios:run:device }

        desc 'Build the app for iOS'
        task :build do
          forge 'build ios'
        end

        desc 'Package the app for iOS deveployment in the simulator or device'
        task :package  => %W{ #{tasks_namespace}:ios:build }do
          forge 'package ios'
        end

        desc 'Run the app in the location specified in the local_config.json'
        task :run  => %W{ #{tasks_namespace}:ios:package } do
          forge 'run ios'
        end

        namespace :run do
          desc 'Run the app in the simulator'
          task :device => %W{ #{tasks_namespace}:ios:package } do
            forge 'run ios --ios.device device'
          end

          desc 'Run the device on the device'
          task :simulator => %W{ #{tasks_namespace}:ios:package } do
            forge 'run ios --ios.device simulator'
          end

          namespace :simulator do
            desc 'Force the app to run in the iPhone simulator'
            task :iphone  => %W{ #{tasks_namespace}:ios:package } do
              forge 'run ios --ios.device simulator --ios.simulatorfamily iphone'
            end
            desc 'Force the app to run in the iPad simulator'
            task :ipad  => %W{ #{tasks_namespace}:ios:package } do
              forge 'run ios --ios.device simulator --ios.simulatorfamily ipad'
            end
          end
        end

      end



    end


  end
end

