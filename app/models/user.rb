class User < ApplicationRecord
  enum role: [:user, :vip, :admin]
  after_initialize :set_default_role, if: :new_record?

  def set_default_role
    self.role ||= :user
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  validate do
    if password.present? && !password.match(/^(?=.*\d)(?=.*\W)/)
      errors.add :password, I18n.t('user.password_complexity')
    end
  end

  def name
    "#{first_name} #{last_name}"
  end
end
