# frozen_string_literal: true

module Api
  module V1
    module Package
      class IndexInteraction < BaseInteraction
        integer :page, default: 1
        integer :per, default: 100

        def execute
          serialize_all ::Package.page(page).per(per)
        end

        private

        def serialize_all(data)
          {
            per: per,
            page: data.current_page,
            total: data.total_count,
            items: data.map(&method(:serialize_one))
          }
        end

        def serialize_one(item)
          {
            id: item.id.to_s,
            name: item.name
          }
        end
      end
    end
  end
end