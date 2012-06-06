#Comment this if not using rvm
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function
rvm use 1.9.3-falcon

#Change this path to rails root
cd ~/www/current

#rvm use 1.9.3-falcon
RAILS_ENV=production RAILS_PATH=`pwd` bundle exec rake unicorn:restart

