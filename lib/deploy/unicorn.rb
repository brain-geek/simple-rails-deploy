namespace :deploy do
  desc "Start unicorn"
  task :start do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} RAILS_PATH=#{current_path} bundle exec rake unicorn:start"
  end

  desc "Restart unicorn"
  task :restart do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} RAILS_PATH=#{current_path} bundle exec rake unicorn:restart"
  end
end

