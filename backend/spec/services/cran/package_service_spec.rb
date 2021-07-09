# frozen_string_literal: true

describe ::Cran::PackageService do
  let(:expectation) do
    [
      { name: 'A3', version: '1.0.0', checksum: '027ebdd8affce8f0effaecfcd5f5ade2' },
      { name: 'aaSEA', version: '1.1.0', checksum: '0f9aaefc1f1cf18b6167f85dab3180d8' },
      { name: 'AATtools', version: '0.0.1', checksum: '3bd92dbd94573afb17ebc5eab23473cb' }
    ]
  end

  it 'should receive packages and extract name, version, and checksum' do
    VCR.use_cassette('packages') do
      result = []
      described_class.receive_each_package { |package| result << package }
      expect(result).to eq expectation
    end
  end
end
