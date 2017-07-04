describe CallPolicy do
  subject { CallPolicy }

  let(:admin) { create :user, :admin }
  let(:u1)  { create :user  }
  let(:u2)  { create :user  }

  let!(:c1) { create :call, user: u1 }
  let!(:c2) { create :call, user: u2 }

  describe :scope do
    it 'owned calls for :user' do
      policy_scope = CallPolicy::Scope.new(u1, Call).resolve
      expect(policy_scope).to eq [c1]
      policy_scope = CallPolicy::Scope.new(admin, Call).resolve
      expect(policy_scope).to match_array [c1, c2]
    end
  end

  permissions :index? do
    it 'grant access for all roles' do
      expect(subject).to permit(u1)
      expect(subject).to permit(admin)
    end
  end

  permissions :update? do
    it 'users can not update calls' do
      expect(subject).not_to permit(u1, c1)
    end
  end

  [:update?, :destroy?].each do |action|
    permissions action do
      it 'grant access to owned calls for :user' do
        expect(subject).not_to permit(u1, c1)
        expect(subject).not_to permit(u2, c1)
        expect(subject).not_to permit(u1, c2)
        expect(subject).not_to permit(u2, c2)
      end
      it 'grant access to all calls for :admin' do
        expect(subject).to permit(admin, c1)
        expect(subject).to permit(admin, c2)
      end
    end
  end

  permissions :show? do
    before do
      c1.date_time = 2.days.ago
      c2.date_time = 2.days.ago
    end
    it 'grant access to owned calls for :user' do
      expect(subject).to permit(u1, c1)
      expect(subject).not_to permit(u2, c1)
      expect(subject).not_to permit(u1, c2)
      expect(subject).to permit(u2, c2)
    end
    it 'grant access to all calls for :admin' do
      expect(subject).to permit(admin, c1)
      expect(subject).to permit(admin, c2)
    end
    it 'grant access if call is in the past' do
      expect(subject).to permit(u1, c1)
      c1.date_time = Time.now + 2.days
      expect(subject).to permit(u1, c1)
    end
  end

  permissions :create? do
    it 'grant access for all roles' do
      expect(subject).not_to permit(u1)
      expect(subject).to permit(admin)
    end
  end
end
