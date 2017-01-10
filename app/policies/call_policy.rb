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
    user.admin? || user.calls.include?(record)
  end

  def create?
    true
  end

  def update?
    show?
  end

  def destroy?
    show?
  end
end
