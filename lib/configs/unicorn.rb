rails_root = ENV['RAILS_PATH'] || raise("Rails path unknown")
pid_file   = "#{rails_root}/tmp/pids/unicorn.pid"
socket_file= "#{rails_root}/tmp/unicorn.sock"
log_file   = "#{rails_root}/log/unicorn.log"
err_log    = "#{rails_root}/log/unicorn_error.log"
old_pid    = pid_file + '.oldbin'

timeout 30
worker_processes ENV['WORKERS_COUNT'].to_i || raise("Workers count not specified") # Based on load and other stuff
listen socket_file, :backlog => 1024
pid pid_file
stderr_path err_log
stdout_path log_file

#preload_app true # Master loads app before forking
preload_app false

GC.copy_on_write_friendly = true if GC.respond_to?(:copy_on_write_friendly=) # ree garbage collection tuning

before_exec do |server|
  ENV["BUNDLE_GEMFILE"] = "#{rails_root}/Gemfile"
end

before_fork do |server, worker|
  # Disconnect from DB before forking
  defined?(ActiveRecord::Base) and
  ActiveRecord::Base.connection.disconnect!

  #0 downtime deploy magic
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  # Reconnect to db after forking
  defined?(ActiveRecord::Base) and
  ActiveRecord::Base.establish_connection
end
