# frozen_string_literal: true

module Api
  module V1
    module Package
      class IndexInteraction < BaseInteraction
        integer :page, default: 1
        integer :per, default: 10

        def execute
          serialize_all ::Package.collection.aggregate(
            [
              {
                '$facet': {
                  metadata: [{ '$count': 'total' }],
                  items: [
                    {
                      '$lookup' => {
                        from: 'versions',
                        as: 'version',
                        let: { pid: '$_id' },
                        pipeline: [
                          { '$match' => { '$expr' => { '$eq' => ['$$pid', '$package_id'] } } },
                          { '$sort' => { 'published_at' => -1 } },
                          { '$limit' => 1 }
                        ]
                      }
                    },
                    {
                      '$project': {
                        version: { number: 1 },
                        checksum: 1,
                        name: 1
                      }
                    },
                    { '$skip': (page - 1) },
                    { '$limit': per }
                  ]
                }
              },
              {
                '$project': {
                  total: { '$arrayElemAt' => ['$metadata.total', 0] },
                  items: 1
                }
              }
            ]
          )
        end

        private

        def serialize_all(data)
          data = data&.first&.with_indifferent_access
          return {} unless data

          {
            per: per,
            page: page,
            total: data[:total],
            items: data[:items].map(&method(:serialize_one))
          }
        end

        def serialize_one(item)
          item[:version] = item[:version].last[:number]
          item[:_id] = item[:_id].to_s
          item
        end
      end
    end
  end
end
