describe Call, type: :model do
  it { should belong_to :user }
  it { should validate_presence_of :dial_in }
  it { should validate_presence_of :participant_code }
  it { should validate_presence_of :date_time }
  it { should validate_presence_of :user }
end
