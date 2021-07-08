

gem install foreman

Depends on the number of cores (for me, it is 4 cores), we can tune Sidekiq processes. However, based on best practices, it is recommended not to use more than 50 threads (concurrency value in Sidekiq configs) per single core.