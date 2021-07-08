# frozen_string_literal: true

class Version
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  field :title, type: String
  field :number, type: String
  field :description, type: String
  field :published_at, type: DateTime

  belongs_to :package

  has_and_belongs_to_many :authors, class_name: 'Contributor',
                                    inverse_of: nil, autosave: true

  has_and_belongs_to_many :maintainers, class_name: 'Contributor',
                                        inverse_of: nil, autosave: true
end
