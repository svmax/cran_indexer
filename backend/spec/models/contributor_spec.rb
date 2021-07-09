describe Contributor, type: :model do
  it { is_expected.to be_mongoid_document }
  it { is_expected.to be_dynamic_document }

  it { is_expected.to have_field(:name).of_type(String) }
  it { is_expected.to have_field(:email).of_type(String) }
end
