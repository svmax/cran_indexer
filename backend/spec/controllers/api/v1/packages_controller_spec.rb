# frozen_string_literal: true

describe Api::V1::PackagesController, type: :controller do
  describe '#index' do
    it 'should return empty array when nothing was indexed yet' do
      get :index

      expectation = { per: 10, page: 1, total: 0, items:[] }
      expect(response.body).to eq(expectation.to_json)
    end

    context 'package in response' do
      let(:name) { 'AA2' }
      let(:checksum) { 'jqggzbsieackrjob' }
      let!(:package) { create(:package, name: name, checksum: checksum) }

      it 'will return package info' do
        get :index

        data = JSON.parse(response.body)['items']
        expect(data.first['checksum']).to eq checksum
        expect(data.first['name']).to eq name
        expect(data.size).to eq 1
      end

      it 'should pagigate data' do
        FactoryBot.create_list(:package, 10)

        get :index

        data = JSON.parse(response.body)
        expect(data['items'].size).to eq 10
        expect(data['total']).to eq 11
        expect(data['per']).to eq 10
        expect(data['page']).to eq 1

        get :index, params: { page: 2 }

        data = JSON.parse(response.body)
        expect(data['items'].size).to eq 1
        expect(data['total']).to eq 11
        expect(data['per']).to eq 10
        expect(data['page']).to eq 2
      end
    end
  end

  describe '#show' do
    let!(:package) { create(:package, name: 'cranR') }

    before { create(:version, package_id: package, number: '1.0.3') }

    it 'should return empty array when nothing was indexed yet' do
      get :show, params: { id: package.id }

      data = JSON.parse(response.body)
      expect(data['name']).to eq 'cranR'

      versions = data['versions']
      expect(versions.size).to eq 1
      expect(versions.first['number']).to eq '1.0.3'
      expect(versions.first['authors'].size).to eq 1
      expect(versions.first['maintainers'].size).to eq 1
      expect(versions.first['authors'].first.keys).to eq ['name', 'email']
    end
  end
end
