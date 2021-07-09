# frozen_string_literal: true

describe ApplicationController, type: :controller do
  controller do
    def index
      raise 'Unexpected error!'
    end
  end

  describe 'handling exceptions' do
    it 'return json with error' do
      get :index

      expect(response.body).to eq "{\"error\":\"Error occurred! Please, contact support.\"}"
    end
  end
end
