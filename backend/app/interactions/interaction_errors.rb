# frozen_string_literal: true

module InteractionErrors
  class InteractionArgumentError < StandardError
    attr_reader :errors

    def initialize(errors)
      @errors = errors
    end

    def to_h(_)
      { message: errors.full_messages.join("\n") }
    end

    def to_s
      return errors.full_messages.join("\n") if errors.present? && errors.respond_to?(:full_messages)

      super
    end

    alias_method :as_json, :to_h
  end
end
