describe User do
  before(:each) { @user = User.new(email: 'user@example.com') }

  subject { @user }
  let(:user) { create :user }

  it { should respond_to(:email) }

  it '#email returns a string' do
    expect(@user.email).to match 'user@example.com'
  end

  describe 'validate password complexity' do
    %w(123 aaa _).each do |pwd|
      it "'#{pwd}' not valid" do
        user = build :user, password: pwd, password_confirmation: pwd
        expect(user).not_to be_valid
        expect(user.errors[:password])
          .to include I18n.t('user.password_complexity')
      end
    end
    %w(123a?678 =3albaso).each do |pwd|
      it "'#{pwd}' valid" do
        user = build :user, password: pwd, password_confirmation: pwd
        expect(user).to be_valid
      end
    end
  end

  describe 'Autharitative modes' do
    it 'should have blocked and suspended to false by default' do
      expect(user).not_to be_blocked
      expect(user).not_to be_suspended
    end

    it '.suspend! to be .suspended?' do
      user.suspend!
      expect(user).to be_suspended
    end
    it '.activate! to be .active?' do
      user.suspend!
      user.activate!
      expect(user).to be_active
    end

    it '.block! to be .blocked?' do
      user.block!
      expect(user).to be_blocked
    end
    it '.allow! or unblock! to be .allowed?' do
      user.block!
      user.allow!
      expect(user).to be_allowed
      user.block!
      user.unblock!
      expect(user).to be_allowed
    end
  end
end
