mongo: mongod --dbpath ./dbs/mongo
redis: cd ./dbs/redis && redis-server service-rails.conf
sidekiq_dispatcher_and_scheduler: cd ./backend && bundle exec sidekiq -C config/sidekiq_dispatcher.yml
sidekiq_versioning: cd ./backend && bundle exec sidekiq -C config/sidekiq_versioning.yml
rails: cd ./backend && bundle exec rails s -p 3000
frontend: cd ./frontend && yarn serve