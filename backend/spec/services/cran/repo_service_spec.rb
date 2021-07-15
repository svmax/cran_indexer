# frozen_string_literal: true

describe ::Cran::RepoService do
  let(:package_name) { 'A3' }
  let(:package_version) { '1.0.0' }

  before do
    archive = download_archive(package_name, package_version)
    allow(::Cran::RepoService).to receive(:download_archive).and_return(archive)
  end

  it 'should extract description from downloaded packge archive' do
    data = ::Cran::RepoService.receive_description(package_name, package_version)
    expect(data[:title]).to eq 'Accurate, Adaptable, and Accessible Error Metrics for Predictive'
    expect(data[:maintainers]).to eq [{ email: 'scottfr@berkeley.edu', name: 'Scott FortmannRoe' }]
    expect(data[:authors]).to eq [{ email: nil, name: 'Scott FortmannRoe' }]
    expect(data[:published_at]).to eq '2015-08-16 23:05:52'
    expect(data[:number]).to eq package_version
  end
end
