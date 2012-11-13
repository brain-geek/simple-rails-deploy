Simple rails deploy
===================

This gem is made to get everything I need for deploy in one place:
* capistrano configuration
* unicorn configuration and startup rake task
* nginx configuration
* all stuff and magic to use this all together

Assumptions
========
* Project uses ruby 1.9.3 for deployment.
* Project uses asset pipeline for asset packing.
* Project uses bundler to handle dependencies.
* Project uses git.
* Each project has its own user.

What does it provide
=======
Configless unicorn control and configuration: tasks unicorn:start, unicorn:restart, unicorn:stop.
Small common capistrano recipes.

Limitations
========
Unicorn can be less flexibly configured

Step by step instruction
======

Server-side:
(as root)
```bash
# Server initial setup
apt-get install build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion
#Use other package if not using PostgreSQL
apt-get install postgresql libpq-dev

# Creating new ssh user
adduser <project-name>
cd ~<project-name>
mkdir .ssh
nano .ssh/authorized_keys
#(paste your public ssh key in editor)
chmod -R 700 .ssh
chown -R <project-name>:<project-name> .ssh

# Database credentials
su postgres
createuser <project-name>
# Allow only database creation, not superuser
```

And you should add nginx config:
```nginx
server {
  server_name <domain to use>;

  root   /home/<projectname>/app/current/public;
  try_files $uri/index.html $uri.html $uri @app;

  location @app {
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $http_host;
    proxy_redirect off;

    # If you don't find the filename in the static files
    # Then request it from the unicorn server
    proxy_pass http://unix:/home/<projectname>/app/shared/tmp/unicorn.sock:;
  }
}
```

That's all for root. Everything else will be done without superuser privileges.

In application code folder:
Run 'capify .' command. Replace config/deploy.rb:
```ruby
require 'simple-rails-deploy/common'

#Use rvm with ruby 1.9.3 for deployment
load 'deploy/rvm'
#Use unicorn as web server
load 'deploy/unicorn'
#Uncomment if you want to add 'deny all' robots.txt on deploy
#load 'deploy/robots-deny-all'

#multistaging
require "capistrano/ext/multistage"
set :stages, %w(demo)
set :default_stage, "demo"
set :keep_releases, 5

set :application, "<application name>"
set :repository,  "<repo name>"

```

create file config/deploy/[stage-name].rb with contents:
```ruby
# Path to deploy folder is calculated based on appication name:
# set :deploy_to, "/home/#{application}/app/"
# Username is the same as application name:
# set :user, application

#set rails environment here
set :rails_env, "production"

#set git branch here
set :branch, "master"

#set server address here
set :domain, "<server-hostname>" # Required for ssh deploy

#Server roles
role :web, domain
role :app, domain
role :db,  domain, :primary => true
```

And run:
```bash
#Remove deploy:create_database if you do not need to setup database and/or create database.yml file
#Set up rvm, install ruby, initial project deploy
cap <stagename> rvm:install_rvm rvm:install_ruby deploy:create_database deploy:setup deploy:cold deploy:migrate deploy
```
Adding custom config files
======

Put them into '/home/youruser/app/shared/' folder and add to delpoy.rb:
```ruby
set :normal_symlinks, %w(
    config/database.yml
    tmp
    config/first_custom_config.yml
    config/second_custom_config.yml
)
```

License
======
Copyright 2012, Alexander Rozumiy. Distributed under the MIT license.

Thanks to @Slotos for help with initial configuration files.