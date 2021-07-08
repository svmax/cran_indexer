# frozen_string_literal: true

class DispatcherWorker
  include Sidekiq::Worker
  sidekiq_options queue: :package_dispatcher

  def perform
    ::Cran::PackageService.receive_each_package do |params|
      package = ::Package.find_by(name: params[:name])
      next save_and_index_package!(params) unless package

      if package.checksum != params[:checksum]
        update_and_index_package!(params.merge(package_id: package.id.to_s))
      end
    end
  end

  private

  def save_and_index_package!(params)
    package = ::Package.create(params.slice(:name, :checksum))
    indexer_args = params.except(:checksum).merge(package_id: package.id.to_s)
    ::IndexerWorker.perform_async(indexer_args)
  end

  def update_and_index_package!(params)
    ::Package.update(params.slice(:checksum))
    ::IndexerWorker.perform_async(params.except(:checksum))
  end
end
