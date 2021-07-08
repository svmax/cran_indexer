# frozen_string_literal: true

module Interactionable
  extend ActiveSupport::Concern

  class_methods do
    def render_interactions(*actions)
      actions.each do |action|
        define_method(action) do
          render_interaction action: action
        end
      end
    end
  end

  def render_interaction(
    action:,
    success: ->(int) { render_interaction_success(int) },
    failure: ->(int) { render_interaction_errors(int) }
  )
    klass = interaction_klass(action)
    args = prepare_params(klass)
    interaction = klass.run(args)
    status = interaction.valid?
    (status ? success : failure)[interaction]
  ensure
    Rails.logger.debug "Interaction: '#{klass}', valid? #{status}"
  end

  private

  def render_interaction_success(int)
    render int.result.nil? ? { nothing: true, status: :no_content } : { json: int.result, status: int.status }
  end

  def render_interaction_errors(int)
    render json: { error: int.errors.full_messages.join('; ') }, location: false, status: :unprocessable_entity
  end

  def prepare_params(klass)
    snakecase_keys(params.permit!.to_h).slice(*klass.filters.keys)
  end

  def interaction_klass(action)
    action_name = action.to_s.classify
    controller_name = self.class.name.sub(/Controller$/, '').classify
    "#{controller_name}::#{action_name}Interaction".constantize
  end

  def deep_transform_keys(hash, &block)
    hash.reduce({}) do |h, (k, v)|
      h[yield(k)] ||= v.is_a?(Hash) ? deep_transform_keys(v, &block) : v
      h
    end
  end

  def snakecase_keys(hash)
    deep_transform_keys(hash) { |k| k.to_s.underscore.to_sym }
  end
end
