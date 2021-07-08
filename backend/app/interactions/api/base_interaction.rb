# frozen_string_literal: true

module Api
  class BaseInteraction < ActiveInteraction::Base
    include InteractionErrors

    attr_accessor :status

    def run
      raise InteractionArgumentError.new(errors) unless valid?

      self.status ||= :ok
      self.result =
        begin
          output = execute
          raise InteractionArgumentError.new(errors) if errors.any?

          output
        rescue Interrupt => e
          raise Interaction::ArgumentError, e.outcome.errors
        end
    end
  end
end
