# frozen_string_literal: true

class IndexerWorker
  include Sidekiq::Worker
  sidekiq_options queue: :versioning

  def perform(args)
    args = args.with_indifferent_access
    description_fields = %i[title number description published_at]
    data = ::Cran::RepoService.receive_description(args[:name], args[:version])
    version_params = data.slice(*description_fields).merge(package_id: args[:package_id])

    version = ::Version.find_or_initialize_by(version_params.slice(:package_id, :number))
    find_or_create_contributors(data[:maintainers]).each { |memo| version.maintainers << memo }
    find_or_create_contributors(data[:authors]).each { |memo| version.authors << memo }
    version.attributes = version_params
    version.save
  end

  private

  def find_or_create_contributors(data)
    data.map do |item|
      contr = ::Contributor.find_or_initialize_by(name: item[:name])
      next(contr) if contr.email.present? && contr.name.present?

      contr.email = item[:email] if item[:email].present?
      contr.save
      contr
    end
  end
end
