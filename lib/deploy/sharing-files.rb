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