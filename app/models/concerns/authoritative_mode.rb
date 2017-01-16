module AuthoritativeMode
  extend ActiveSupport::Concern

  def suspend
    update_attribute :suspended, true
  end

  def activate
    update_attribute :suspended, false
  end

  def active?
    !suspended
  end

  def block
    update_attribute :blocked, true
  end

  def allow
    update_attribute :blocked, false
  end

  def unblock
    allow
  end

  def allowed?
    !blocked
  end

  def status
    "#{active? ? 'active' : 'suspended'} | #{allowed? ? 'allowed' : 'blocked'}"
  end
end
