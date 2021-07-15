# frozen_string_literal: true

class DispatcherWorker
  include Sidekiq::Worker
  sidekiq_options queue: :package_dispatcher

  def perform
    # params: { name: String, version: String, checksum: String }
    ::Cran::PackageService.receive_each_package do |params|
      package = ::Package.find_by(name: params[:name])
      next save_and_index_package!(params) unless package

      if package.checksum != params[:checksum]
        update_and_index_package!(package, params.merge(package_id: package.id.to_s))
      end
    end
  end

  private

  def save_and_index_package!(params)
    package_args = params.slice(:checksum, :name)
    package = ::Package.find_or_create_by(package_args)

    package_args[:version] = params[:version]
    package_args[:package_id] = package.id.to_s
    ::IndexerWorker.perform_async(package_args)
  end

  def update_and_index_package!(package, params)
    package.update(checksum: params[:checksum])
    ::IndexerWorker.perform_async(params.slice(:name, :version, :package_id))
  end
end
