Sidekiq.configure_server do |config|
  config.periodic do |mgr|
    # A task that will run every day at 12pm
    mgr.register('0 0 12 * * ?', DispatcherWorker)
  end
end