# frozen_string_literal: true

module Api
  module V1
    module Package
      class ShowInteraction < BaseInteraction
        string :id

        def execute
          serialize ::Package.find(id)
        end

        private

        def serialize(item)
          {
            name: item.name,
            id: item.id.to_s,
            versions: extract_versions(item)
          }
        end

        def extract_versions(package)
          package.versions.includes(:authors, :maintainers).map do |version|
            maintainers = version.maintainers.map(&method(:extract_contributor))
            authors = version.authors.map(&method(:extract_contributor))
            {
              title: version.title,
              number: version.number,
              description: version.description,
              published_at: version.published_at,
              maintainers: maintainers,
              authors: authors
            }
          end
        end

        def extract_contributor(item)
          { name: item.name, email: item.email }
        end
      end
    end
  end
end
