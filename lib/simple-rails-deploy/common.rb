# Bundler integration - installs same gems as in development
require 'bundler/capistrano'
# Colored capistrano output
require 'capistrano_colors'

Capistrano::Configuration.instance(true).load do
  @load_paths += [Gem::Specification.find_by_name("simple-rails-deploy").gem_dir+'/lib']

  load 'deploy/assets'
  load 'deploy/sharing-files'
  load 'deploy/add-to-autostart'

  # VCS settings
  set :scm, :git
  set :deploy_via, :remote_cache
  set :ssh_options, { :forward_agent => true }

  # Server settings
  set :use_sudo, false

  # Hack to make forward_agent work
  on :start do
    `ssh-add`
  end

  # Deployment path
  set(:deploy_to) { "/home/#{application}/app/" }

  set(:user) { application }

  set :keep_releases, 25
  after "deploy:update", "deploy:cleanup" 
end

