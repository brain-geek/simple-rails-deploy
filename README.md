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
- Project uses ruby 1.9.3 for deployment.
- Project uses asset pipeline for asset packing.
- Project uses bundler to handle dependencies.
- Project uses git.
- Each project has its own user(all path assumptions are based on this).
- Nobody likes setting up ruby web servers.

What does it provide
=======
Configless unicorn control and configuration: tasks unicorn:start, unicorn:restart, unicorn:stop.
Small common capistrano recipes.

Limitations
========
- Unicorn can be less flexibly configured

License
======
Copyright 2012, Alexander Rozumiy. Distributed under the MIT license.

Thanks to @Slotos for help with initial configuration files.