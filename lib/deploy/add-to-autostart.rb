namespace :deploy do
  task :add_to_startup do
    startup_sh = '#!/bin/bash
      #Comment this if not using rvm
      [[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function
      rvm use 1.9.3-falcon

      export rvm_project_rvmrc=0

      #Change this path to rails root
      cd ~/app/current

      #rvm use 1.9.3-falcon
      RAILS_ENV=production RAILS_PATH=`pwd` bundle exec rake unicorn:start'

    put startup_sh, "/home/#{application}/startup.sh", :mode => '755'

    begin
      run "crontab -l > ~/#{application}-cron"
    rescue
      #no crontab present
    end

    run "echo '#Begin reload on reboot task' >> ~/#{application}-cron"
    run "echo '@reboot /bin/bash /home/#{application}/startup.sh' >> ~/#{application}-cron"
    run "echo '#End reload on reboot task' >> ~/#{application}-cron"
    run "crontab ~/#{application}-cron"
    run "rm ~/#{application}-cron"
  end
end