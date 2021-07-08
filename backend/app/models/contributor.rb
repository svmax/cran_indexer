# frozen_string_literal: true

class Contributor
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  field :name, type: String
  field :email, type: String
end
