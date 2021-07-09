# frozen_string_literal: true

FactoryBot.define do
  factory :package do
    name { Faker::Name.name }
    checksum { Faker::Alphanumeric.alpha(number: 16) }
  end
end
