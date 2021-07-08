# frozen_string_literal: true

module Api
  module V1
    module Package
      class ShowInteraction < BaseInteraction
        string :id

        def execute
          ::Package.find(id)
        end
      end
    end
  end
end
