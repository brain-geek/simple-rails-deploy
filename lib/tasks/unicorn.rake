namespace :unicorn do
  def rails_root
    ENV['RAILS_PATH'] || Rails.root
  end

  def unicorn_pid
    File.join(rails_root, 'tmp', 'pids', 'unicorn.pid')
  end

  def unicorn_config
    gem_path = Gem::Specification.find_by_name("simple-rails-deploy").gem_dir
    File.join(gem_path, 'lib', 'configs', 'unicorn.rb')
  end

  def workers_count
    if Rails.env.staging?
      return 1
    elsif Rails.env.production?
      # workers count == cpu cores count
      # cpu count code is from https://gist.github.com/1009994
      module System
        extend self
        def cpu_count
          return Java::Java.lang.Runtime.getRuntime.availableProcessors if defined? Java::Java
          return File.read('/proc/cpuinfo').scan(/^processor\s*:/).size if File.exist? '/proc/cpuinfo'
          require 'win32ole'
          WIN32OLE.connect("winmgmts://").ExecQuery("select * from Win32_ComputerSystem").NumberOfProcessors
        rescue LoadError
          Integer `sysctl -n hw.ncpu 2>/dev/null` rescue 1
        end
      end

      return System.cpu_count
    else
      return 2
    end
  end

  desc "Start unicorn"
  task :start do
    # Get unicorn pid
    pidfile = unicorn_pid
    if File.exists? pidfile
      abort 'Unicorn is already running'
    else
      system_call = "env RAILS_PATH=#{rails_root} WORKERS_COUNT=#{workers_count} bundle exec unicorn_rails -c #{unicorn_config} -D"
      if system(system_call)
        puts "Started and running with pid: #{File.read pidfile}" 
      else
        puts "Unicorn failed to start. System call was: '#{system_call}' "
      end
    end
  end

  desc "Restart unicorn"
  task :restart do
    # Get unicorn pid
    pidfile = unicorn_pid
    old_pidfile = unicorn_pid + '.oldbin'
    abort 'unicorn is either restarting or encounetred a serious crash in the previous restart attempt' if File.exists? old_pidfile
    if File.exists? pidfile
      begin
        pid = File.read(pidfile).to_i
        Process.kill 0, pid
        Process.kill "USR2", pid
        puts "Successfully asked unicorn to reload gracefully"
      rescue Errno::EPERM
        abort 'Lacking the rights to communicate with unicorn process'
      rescue Errno::ESRCH
        puts "Something bad happened in the past. Unicorn PID is here, unicorn is not. Starting a new instance."
        File.delete pidfile
        Rake::Task["unicorn:start"].invoke
      end
    else
      puts "Unicorn is not running. Starting a new instance."
      Rake::Task["unicorn:start"].invoke
    end
  end

  desc "Stop unicorn"
  task :stop do
    # Get unicorn pid
    pidfile = unicorn_pid
    if File.exists? pidfile
      begin
        pid = File.read(pidfile).to_i
        Process.kill 0, pid
        Process.kill "QUIT", pid
        puts "Successfully asked unicorn to shut down gracefully"
      rescue Errno::EPERM
        abort 'Lacking the rights to communicate with unicorn process'
      rescue Errno::ESRCH
        puts "Something bad happened in the past. Unicorn PID is here, unicorn is not"
      end
    else
      puts "Unicorn is not running. Aborting"
    end
  end
end