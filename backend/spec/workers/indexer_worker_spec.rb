# frozen_string_literal: true

describe IndexerWorker, type: :worker do
  describe 'properties' do
    it 'will check name of the queue' do
      expect(described_class.queue).to eq :versioning
    end

    it 'will make sure that IndexerWorker jobs are enqueued in the scheduled queue' do
      expect { described_class.perform_async }.to change(described_class.jobs, :size).by(1)
    end

    context 'dispatched data' do
      let(:checksum) { '027ebdd8affce8f0effaecfcd5f5ade2' }
      let(:version) { '1.0.0' }
      let(:name) { 'A3' }

      before do
        VCR.use_cassette('packages') { DispatcherWorker.new.perform }

        archive = download_archive(name, version)
        allow(::Cran::RepoService).to receive(:download_archive).and_return(archive)
      end

      it 'should download dummy archive, extract data and create new version of package' do
        expect(Version.count).to eq 0

        pkg = ::Package.find_by(name: name)
        indexer_args = { name: name, version: version, checksum: checksum, package_id: pkg.id.to_s }
        described_class.new.perform(indexer_args)

        expect(pkg.versions.size).to eq 1
      end
    end
  end
end