require 'rails'

module SimpleRailsDeploy
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'tasks/unicorn.rake'
    end
  end
end