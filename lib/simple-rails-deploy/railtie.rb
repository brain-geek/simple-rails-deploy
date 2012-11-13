require 'rails'

module SimpleRailsDeploy
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'tasks/unicorn.rake'
    end

    generators do
      require "deploy/stage/stage_generator"
    end        
  end
end