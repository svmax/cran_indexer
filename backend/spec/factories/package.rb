# frozen_string_literal: true

FactoryBot.define do
  factory :package do
    name { Faker::Name.name }
    checksum { Faker::Alphanumeric.alpha(number: 16) }

    trait :with_version do
      after :create do |package|
        package.versions << create(:version, package_id: package.id)
        package.save
      end
    end
  end
end
