describe Version, type: :model do
  it { is_expected.to be_mongoid_document }
  it { is_expected.to be_dynamic_document }

  it { is_expected.to have_field(:title).of_type(String) }
  it { is_expected.to have_field(:number).of_type(String) }
  it { is_expected.to have_field(:description).of_type(String) }
  it { is_expected.to have_field(:published_at).of_type(DateTime) }

  it { is_expected.to have_index_for(package_id: 1, number: 1).with_options(unique: true) }

  it { is_expected.to have_and_belong_to_many(:authors).of_type(Contributor).as_inverse_of(nil).with_autosave }
  it { is_expected.to have_and_belong_to_many(:maintainers).of_type(Contributor).as_inverse_of(nil).with_autosave }
end
