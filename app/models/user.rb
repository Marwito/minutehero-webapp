class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  validate do
    if password.present? && !password.match(/^(?=.*\d)(?=.*\W)/)
      errors.add :password, I18n.t('user.password_complexity')
    end
  end

  include TableFilters
  columns_filtered :email, :first_name, :last_name, :company, :country
  include AuthoritativeMode

  delegate :to_s, to: :name
  def name
    "#{first_name} #{last_name}"
  end

  ROLES = %w(user admin)
  enum role: ROLES
  after_initialize :set_default_role, if: :new_record?
  def set_default_role
    self.role ||= :user
  end

  has_many :identities
  has_many :calls, dependent: :destroy
  belongs_to :product, optional: true

  # rubocop: disable AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/LineLength, Metrics/PerceivedComplexity
  def self.find_for_oauth(auth, signed_in_resource = nil)
    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity)
    # which can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?
      # Check if user exists by email
      email = auth.info.email
      user = User.where(email: email).first if email
      # Create the user if it's a new registration
      if user.nil?
        user = User.new(
          first_name: auth.info.first_name || auth.info.name,
          last_name: auth.info.last_name || '-',
          email: email || "change@me-#{auth.uid}-#{auth.provider}.com",
          password: "#{Devise.friendly_token[0, 20]}9?"
        )
        user.skip_confirmation!
        user.save!
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end

    user
  end
  # rubocop: enable all

  def email_verified?
    email # && self.email !~ TEMP_EMAIL_REGEX
  end
end
