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
  end
end