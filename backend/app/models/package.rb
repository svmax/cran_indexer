# frozen_string_literal: true

class Package
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  field :name, type: String
  field :checksum, type: String

  has_many :versions, dependent: :destroy
end
