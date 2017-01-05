describe Identity, type: :model do
  it { should belong_to :user }

  it { should validate_presence_of :uid }
  it { should validate_presence_of :provider }
  it { should validate_uniqueness_of(:uid).scoped_to :provider }

  describe '.find_for_auth' do
    let(:id) { build :identity }
    it 'should return not persisted identity if does not find it' do
      expect { Identity.find(uid: id.uid) }
        .to raise_exception(ActiveRecord::RecordNotFound)

      expect(Identity.find_for_oauth(id).errors).not_to be_empty
    end
    it 'should return identity if finds it' do
      id.user = create :user
      id.save
      expect(Identity.find_for_oauth(id)).to eq id
    end
  end
end
