# This task adds robots.txt with 'deny all' to web root
after "deploy:finalize_update", "deploy:robots"

namespace :deploy do
  task :robots do
    run "echo 'User-Agent: *' > #{release_path}/public/robots.txt&&echo 'Disallow: /' >> #{release_path}/public/robots.txt"
  end
end