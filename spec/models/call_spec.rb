describe Call, type: :model do
  let(:user) { create :user }
  let(:call) { create :call, user: user }

  it { should belong_to :user }
  it { should validate_presence_of :dial_in }
  it { should validate_presence_of :participant_code }
  it { should validate_presence_of :schedule_date }
  it { should validate_presence_of :schedule_time }
  it { should validate_presence_of :user_id }

  describe 'should validate :date_time not in the past' do
    now = Time.new(2017, 6, 23, 11, 50, 0, '+00:00')
    time_zone = 'Brasilia' # UTC-03:00
    Timecop.freeze(now) do
      it "When now=#{now} then 2017-06-23 10:50 UTC-03:00 not in the past" do
        call.schedule_date = Date.new(2017, 6, 23)
        call.schedule_time = Time.new(1, 1, 1, 10, 50, 0)
        call.time_zone = time_zone
        expect(call).to be_valid
      end

      it "When now=#{now} then 2017-06-23 07:50 UTC-03:00 in the past" do
        call.schedule_date = Date.new(2017, 6, 23)
        call.schedule_time = Time.new(1, 1, 1, 7, 50, 0)
        call.time_zone = time_zone
        expect(call).not_to be_valid
        expect(call.errors[:date_time]).to include
        I18n.t('call.errors.date_time.past')
      end
    end
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
