describe Package, type: :model do
  it { is_expected.to be_mongoid_document }
  it { is_expected.to be_dynamic_document }

  it { is_expected.to have_field(:name).of_type(String) }
  it { is_expected.to have_field(:checksum).of_type(String) }

  it { is_expected.to have_many(:versions).with_dependent(:destroy) }
end
