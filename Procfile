mongo: mongod --dbpath ./dbs/mongo
redis: cd ./dbs/redis && redis-server service-rails.conf
sidekiq_dispatcher: cd ./backend && bundle exec sidekiq -C config/sidekiq_dispatcher.yml
sidekiq_versioning_1: cd ./backend && bundle exec sidekiq -C config/sidekiq_versioning.yml
sidekiq_versioning_2: cd ./backend && bundle exec sidekiq -C config/sidekiq_versioning.yml
rails: cd ./backend && rails s -p 3000