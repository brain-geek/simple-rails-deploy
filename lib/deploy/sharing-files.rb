#Links files from this list to 'current' folder
set :normal_symlinks, %w(
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

after "deploy:finalize_update", "deploy:app_symlinks"

namespace :deploy do
  task :create_database_yml do
    db_config = ERB.new <<-EOF
    base: &base
      adapter: postgresql
      encoding: unicode
      database: #{application}
      pool: 5
      min_messages: WARNING

    #{rails_env}:
      <<: *base

    development:
      <<: *base
    EOF

    run "mkdir -p #{shared_path}/config"
    put db_config.result, "#{shared_path}/config/database.yml"
  end

  task :create_database do
    run "psql -c'create database #{application};' postgres"    
  end

  task :create_shared_tmp_folder do
    run "mkdir -p #{shared_path}/tmp"
  end

  task :fix_ssh_git do
    run "echo 'StrictHostKeyChecking no' > ~/.ssh/config"
  end
end

before 'deploy:setup', 'deploy:create_database_yml'
before 'deploy:setup', 'deploy:create_shared_tmp_folder'
before 'deploy:setup', 'deploy:fix_ssh_git'