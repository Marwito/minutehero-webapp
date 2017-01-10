describe Call, type: :model do
  let(:user) { create :user }
  let(:call)         { create :call, user: user }

  it { should belong_to :user }
  it { should validate_presence_of :dial_in }
  it { should validate_presence_of :participant_code }
  it { should validate_presence_of :date_time }
  it { should validate_presence_of :user }

  it 'should validate if valid phone' do
    call.dial_in = '333'
    expect(call.valid?).to be false
    expect(call.errors.messages[:dial_in]).to be_any
  end
end
