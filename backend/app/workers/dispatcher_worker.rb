# frozen_string_literal: true

class DispatcherWorker
  include Sidekiq::Worker
  sidekiq_options queue: :package_dispatcher, retry: 1

  def perform
    # params: { name: String, version: String, checksum: String }
    ::Cran::PackageService.receive_each_package do |params|
      package = ::Package.find_or_initialize_by(name: params[:name])
      if package.new_record?
        save_and_index_package!(package, params)
        next
      end

      if package.checksum != params[:checksum]
        update_and_index_package!(package, params)
      end
    end
  end

  private

  def save_and_index_package!(package, params)
    indexer_args = package_args(params)
    package.attributes = indexer_args
    package.save

    indexer_args[:package_id] = package.id.to_s
    ::IndexerWorker.perform_async(indexer_args)
  end

  def update_and_index_package!(package, params)
    indexer_args = package_args(params)
    package.update(checksum: params[:checksum])

    indexer_args[:package_id] = package.id.to_s
    ::IndexerWorker.perform_async(indexer_args)
  end

  def package_args(params)
    params.slice(:checksum, :name, :version)
  end
end
