require 'rake/tasklib'
require 'trigger_tasks/configuration'

class TriggerTasks < ::Rake::TaskLib


  def initialize
    config = Configuration.new
    yield config if block_given?
    define_tasks config
  end


  private

  def define_tasks config

    desc 'Open the app in the device'
    task :device => 'forge:ios:device'

    desc 'Open the app in the simulator'
    task :simlator => 'forge:ios:simulator'

    desc 'Open the app in the iOS simulator'
    task :forge => 'forge:ios'

    namespace config.namespace do

      desc 'Open the app in the iOS simulator'
      task :ios  => %w{ forge:ios:run }

      namespace :ios do

        desc 'Run the app on the device'
        task :device  => %w{ forge:ios:run:device }

        desc 'Build the app for iOS'
        task :build do
          sh 'forge build ios'
        end

        desc 'Package the app for iOS deveployment in the simulator or device'
        task :package  => %w{ forge:ios:build }do
          sh 'forge package ios'
        end

        desc 'Run the app in the location specified in the local_config.json'
        task :run  => %w{ forge:ios:package } do
          sh 'forge run ios'
        end

        namespace :run do
          desc 'Run the app in the simulator'
          task :device => %w{ forge:ios:package } do
            sh 'forge run ios --ios.device device'
          end

          desc 'Run the device on the device'
          task :simulator => %w{ forge:ios:package } do
            sh 'forge run ios --ios.device simulator'
          end

          namespace :simulator do
            desc 'Force the app to run in the iPhone simulator'
            task :iphone  => %w{ forge:ios:package } do
              sh 'forge run ios --ios.device simulator --ios.simulatorfamily iphone'
            end
            desc 'Force the app to run in the iPad simulator'
            task :ipad  => %w{ forge:ios:package } do
              sh 'forge run ios --ios.device simulator --ios.simulatorfamily ipad'
            end
          end
        end

      end

      # Get the provisioning profile
      # desc 'Build and deploy to TestFlight'
      # task :testflight do
      # end

    end


  end
end

