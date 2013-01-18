require 'rake/tasklib'
require 'highline/import'
require 'rest-client'

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
    sh "#{@config.forge_path} #{args}"
  end

  def tasks_namespace
    @config.namespace
  end

  def most_recent_ios_ipa_path
    ipas = Pathname.glob(Pathname.pwd.join('release','ios',"*.ipa"))
    return unless ipas
    ipas.sort.last
  end

  def push_to_testflight options
    unless file = most_recent_ios_ipa_path
      say "No file exists to upload"
      return
    end

    options.api_token = @config.test_flight_api_token
    options.team_token = @config.test_flight_team_token
    options.file = File.new(file, 'rb')

    if @config.verbose
      say """Uploading to TestFlight:
                ipa: #{file}
      release notes: #{options.notes}
  distribution list: #{options.distribution_lists}
       notify users: #{options.notify}
            replace: #{options.replace}
  """
    end

    begin
      response = RestClient.post(@config.test_flight_api_url, options, :accept => :json)
    rescue => e
      response = e.response
    end

    if [200, 201].include? response.code
      puts "Upload to TestFlight complete."
    else
      puts "Upload to TestFlight failed. (#{response})"
    end

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
    task :testflight  => "#{tasks_namespace}:ios:package" do

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
        :distribution_lists => selected_lists,
        :notify => notify_users,
        :replace => replace

    end
  end


  def default_platform_tasks
    platform = @config.default_platform
    desc 'Open the app in the device'
    task :device => "#{tasks_namespace}:#{platform}:device"

    desc 'Open the app in the simulator (aliased to "rake sim")'
    task :simlator => "#{tasks_namespace}:#{platform}:simulator"
    task :sim => "#{tasks_namespace}:#{platform}:simulator"

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
        task :simulator  => %W{ #{tasks_namespace}:ios:run:simulator }

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

