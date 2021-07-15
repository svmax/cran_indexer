# frozen_string_literal: true

FactoryBot.define do
  factory :version do
    title { Faker::Lorem.characters[16] }
    number { Faker::Internet.email }
    description { Faker::Lorem.characters }
    published_at { DateTime.current }

    trait :with_package do
      after :create do |version|
        version.package_id = create(:package).id
        version.save
      end
    end

    trait :with_contributors do
      after :create do |version|
        version.author_ids << create(:contributor).id
        version.maintainer_ids << create(:contributor).id
        version.save
      end
    end
  end
end
