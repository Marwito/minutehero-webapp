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
    admin_or_owned? && record.past?
  end

  def create?
    true
  end

  def update?
    admin_or_owned? && !record.past?
  end

  def destroy?
    admin_or_owned?
  end

  private

  def admin_or_owned?
    user.admin? || user.calls.include?(record)
  end
end
