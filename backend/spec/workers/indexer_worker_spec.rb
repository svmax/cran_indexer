# frozen_string_literal: true

describe IndexerWorker, type: :worker do
  describe 'properties' do
    it 'will check name of the queue' do
      expect(described_class.queue).to eq :versioning
    end

    it 'will make sure that IndexerWorker jobs are enqueued in the scheduled queue' do
      expect { described_class.perform_async }.to change(described_class.jobs, :size).by(1)
    end
  end
end