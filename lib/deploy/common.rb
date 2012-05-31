# Для работы bundler. При изменении гемов bundler автоматически обновит все гемы на сервере, чтобы они в точности соответствовали гемам разработчика.
require 'bundler/capistrano'
# #Colored capistrano output
require 'capistrano_colors'

require './config/boot'
load 'deploy/assets'

#rvm
set :rvm_ruby_string, '1.9.3-falcon'
set :default_environment, {
  'RUBY_HEAP_MIN_SLOTS' => 600000,
  'RUBY_GC_MALLOC_LIMIT' => 59000000,
  'RUBY_HEAP_FREE_MIN' => 100000
}
require "rvm/capistrano"

namespace :rvm do
  task :trust_rvmrc do
    run "rvm rvmrc trust #{release_path}"
  end
end

before 'deploy:setup', 'rvm:install_rvm'
before 'deploy:setup', 'rvm:install_ruby'
after "deploy", "rvm:trust_rvmrc"

#VCS settings
set :scm, :git
set :deploy_via, :remote_cache
ssh_options[:forward_agent] = true


#Server settings
set :use_sudo, false

#Server roles
role :web, domain
role :app, domain
role :db,  domain, :primary => true

on :start do
  `ssh-add`
end

set :normal_sym, %w(
    config/database.yml
    tmp
)

namespace :deploy do
  desc "Use configs"
  task :app_symlinks do
    normal_symlinks.map do |path|
      run "rm -rf #{release_path}/#{path} && ln -nfs #{shared_path}/#{path} #{release_path}/#{path}"
    end
  end
end

after "deploy:finalize_update", "deploy:app_sym"

#Make this cset!
set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"
