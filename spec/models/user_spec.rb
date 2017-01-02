describe User do
  before(:each) { @user = User.new(email: 'user@example.com') }

  subject { @user }

  it { should respond_to(:email) }

  it '#email returns a string' do
    expect(@user.email).to match 'user@example.com'
  end

  describe 'validate password complexity' do
    ['123', 'aaa', '_'].each do |pwd|
      it "'#{pwd}' not valid" do
        user = build :user, password: pwd, password_confirmation: pwd
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include I18n.t( 'user.password_complexity')
      end
    end
    ['123a?678', '=3albaso'].each do |pwd|
      it "'#{pwd}' valid" do
        user = build :user, password: pwd, password_confirmation: pwd
        expect(user).to be_valid
      end
    end
  end

end
