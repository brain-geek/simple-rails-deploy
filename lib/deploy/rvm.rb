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

after "deploy", "rvm:trust_rvmrc"

