class CallPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        Call.all
      else
        user.calls
      end
    end
  end

  def index?
    true
  end

  def show?
    admin_or_owned?
  end

  def create?
    user.admin?
  end

  def update?
    user.admin?
  end

  def destroy?
    user.admin?
  end

  private

  def admin_or_owned?
    user.admin? || user.calls.include?(record)
  end
end
