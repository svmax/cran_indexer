# frozen_string_literal: true

FactoryBot.define do
  factory :version do
    title { Faker::Lorem.characters[16] }
    number { Faker::Internet.email }
    description { Faker::Lorem.characters }
    published_at { DateTime.current }

    package_id { create(:package).id }
    author_ids { [create(:contributor).id] }
    maintainer_ids { [create(:contributor).id] }
  end
end
