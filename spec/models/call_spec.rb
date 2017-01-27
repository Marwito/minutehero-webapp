describe Call, type: :model do
  let(:user) { create :user }
  let(:call) { create :call, user: user }

  it { should belong_to :user }
  it { should validate_presence_of :dial_in }
  it { should validate_presence_of :participant_code }
  it { should validate_presence_of :date_time }
  it { should validate_presence_of :user_id }
  it 'should validate :date_time not in the past' do
    call.date_time = 2.days.ago
    expect(call).not_to be_valid
    expect(call.errors[:date_time]).to include
    I18n.t('call.errors.date_time.past')
  end

  describe 'should validate if valid phone' do
    %w(+49333 +4955555 +491616161616161616).each do |num|
      it "#{num} not valid" do
        call.dial_in = num
        expect(call).not_to be_valid
        expect(call.errors.messages[:dial_in]).to be_any
      end
    end
    %w(+49666666 +49151515151515151).each do |num|
      it "#{num} valid" do
        call.dial_in = num
        expect(call).to be_valid
      end
    end
  end

  describe '#past?' do
    it 'true if call is scheduled in the past' do
      call.date_time = 2.days.ago
      expect(call).to be_past
    end
    it 'false if call is scheduled in the future' do
      expect(call).not_to be_past
    end
  end
end
