# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Interactionable

  rescue_from Exception do |e|
    if e.is_a?(::ActiveInteraction::Errors)
      Rails.logger.error "ERROR: #{e.errors.messages}"
      render json: { error: e.errors.full_messages.join('; ') }, status: :unprocessable_entity
    else
      Rails.logger.error "EXCEPTION: #{e}, PARAMS: #{params.inspect}, BACKTRACE: #{e.backtrace.join("\n")}"
      render json: { error: 'Error occurred! Please, contact support.' }, status: :internal_server_error
    end
  end
end
