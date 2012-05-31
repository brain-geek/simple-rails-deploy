# Для работы bundler. При изменении гемов bundler автоматически обновит все гемы на сервере, чтобы они в точности соответствовали гемам разработчика.
require 'bundler/capistrano'
# #Colored capistrano output
require 'capistrano_colors'

require './config/boot'
load 'deploy/assets'

#rvm
require 'deploy/rvm'
require 'deploy/sharing-files'

#VCS settings
_cset :scm, :git
_cset :deploy_via, :remote_cache
ssh_options[:forward_agent] = true

#Server settings
set :use_sudo, false

#Server roles
role :web, domain
role :app, domain
role :db,  domain, :primary => true

#Hack to make forward_agent work
on :start do
  `ssh-add`
end

# Deployment path
_cset(:deploy_to) { "/home/#{application}/app/" }
