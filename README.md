# README
Cran server indexer

## System dependencies:
* Ruby 2.7.1
* MongoDB
* Redis
* NodeJS
* Foreman

## Setup DB
+ bundle exec rake db:mongoid:create_indexesc

## Configuration
To start all of the needed servers, you could run `foreman start`. In case of the mismatching of your working `bundler` with required by Gemfile, please, try to run all of them in separated console tabs (for comfort):

* `mongod --dbpath ./dbs/mongo`
* `redis-server ./dbs/redis/service-rails.conf`

<Depends on the number of cores (for me, it is 4 cores), we can tune Sidekiq processes. However, based on best practices, it is recommended not to use more than 50 threads (concurrency value in Sidekiq configs) per single core> Backend folder:
* `bundle exec sidekiq -C config/sidekiq/dispatcher.yml`
* `bundle exec sidekiq -C config/sidekiq/versioning.yml`
* `bundle exec sidekiq -C config/sidekiq/cron.yml`
* `bundle exec rails s -p 3000`

Frontend folder:
* `yarn serve`

## Tests and code quality (backend):
+ `rubocop --config .rubocop.yml ./app`
+ `rspec ./spec`

## Services:
+ Based on the ability of the sidekiq to schedule jobs, there are already configured to be turned on at 12 am

## Notes:
+ Some archives are broken or were not uploaded to the Cran server, so there is sometimes a 404 error occurred when trying to download a package
