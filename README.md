Simple rails deploy
===================

This gem is made to get everything I need for deploy in one place. Such as:
- capistrano configuration
- unicorn configuration
- unicorn startup rake task
- nginx configuration
- all stuff and magic to use this all together

Assumptions
========
1. Project uses ruby 1.9.3 for deployment.
2. Project uses unicorn as web server daemon.
3. Project uses bundler to handle dependencies.
4. Project is located on one server.
3. Each project has its own user(all path assumptions are based on this).
4. Nobody likes setting up ruby web servers.

TODO
========
- make it work