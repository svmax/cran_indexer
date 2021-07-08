# frozen_string_literal: true

module Api
  module V1
    class PackagesController < ::ApplicationController
      render_interactions :index, :show
    end
  end
end
