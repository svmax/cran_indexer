# frozen_string_literal: true

describe DispatcherWorker, type: :worker do
  describe 'properties' do
    before(:each) do
      allow(IndexerWorker).to receive(:perform_async).and_return(nil)
    end

    it 'will check name of the queue' do
      expect(described_class.queue).to eq :package_dispatcher
    end

    it 'will make sure that DispatcherWorker jobs are enqueued in the scheduled queue' do
      expect { described_class.perform_async }.to change(described_class.jobs, :size).by(1)
    end

    it 'will create uniq packages and update checksum when needed' do
      VCR.use_cassette('packages') { described_class.new.perform }
      expect(Package.count).to eq 3

      pkg = Package.find_by(checksum: '0f9aaefc1f1cf18b6167f85dab3180d8')
      pkg.update(checksum: 'test')
      expect(pkg.checksum).to eq 'test'

      VCR.use_cassette('packages') { described_class.new.perform }
      expect(Package.count).to eq 3
      expect(pkg.reload.checksum).to eq '0f9aaefc1f1cf18b6167f85dab3180d8'
    end
  end
end