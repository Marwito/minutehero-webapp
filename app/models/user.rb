class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable and :timeoutable
  devise :invitable, :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  include TableFilters
  columns_filtered :email, :first_name, :last_name, :company, :country
  include AuthoritativeMode

  delegate :to_s, to: :name
  def name
    "#{first_name} #{last_name}"
  end

  def name_email
    "#{name} - #{email}"
  end

  ROLES = %w(user admin)
  enum role: ROLES
  after_initialize :set_default_role, if: :new_record?
  def set_default_role
    self.role ||= :user
  end

  TIME_ZONES = ActiveSupport::TimeZone.all
                                      .group_by(&:formatted_offset)
                                      .map do |k, v|
                                        [v.first.name,
                                         "GMT#{k} #{v.map(&:name)
                                                     .take(3).join(', ')}"]
                                      end

  has_many :identities
  has_many :calls, dependent: :destroy
  belongs_to :product, optional: true

  validates :email, :first_name, :last_name, presence: true
  def after_confirmation
    Rails.logger.info 'After confirmation step: Normal Sign-up'
    mn = MailNotifier.new(self, Country.find_by(alpha2_code: country).name,
                          'Directly')
    mn.send
  end

  def confirmed_at_safe
    confirmed_at || '-'
  end

  def update_without_password(params, *options)
    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end

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
          first_name: auth.info.first_name || '-',
          last_name: auth.info.last_name || '-',
          email: email || "change@me-#{auth.uid}-#{auth.provider}.com",
          password: "#{Devise.friendly_token[0, 20]}9?",
          country: nil
        )
        location = auth.info.location || 'Unavailable information'
        user.skip_confirmation!
        user.save!
        Rails.logger.info 'OAuth Sign-up'
        mn = MailNotifier.new(user, location, auth.provider.capitalize)
        mn.send
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

class MailNotifier
  def initialize(user, location, signed_up_via)
    Rails.logger.info 'MailNotifier.initialize is executed for the user: ' \
                      "user_id = #{user.id} #{user.first_name} " \
                      "#{user.last_name}, #{user.email}"
    @user = user
    @aws_region = ENV['aws_region']
    @sender = ENV['send_user_sign_up_notifications_to_email']
    @recipient = ENV['send_user_sign_up_notifications_to_email']
    @country_region = location
    @signed_up_via = signed_up_via
  end

  def send
    require 'aws-sdk'
    ses = Aws::SES::Client.new(region: @aws_region)
    begin
      ses.send_email ses_send_email_arg
      Rails.logger.info 'Notification was sent successfully to admins'
    rescue => e
      Rails.logger.error "Email not sent. Reason : #{e}"
    end
  end

  private

  def ses_send_email_arg
    encoding = 'UTF-8'
    { destination: { to_addresses: [@recipient] },
      message: { subject: { charset: encoding, data: subject },
                 body: { html: { charset: encoding, data: htmlbody } } },
      source: @sender }
  end

  def subject
    "New Sign-up: #{@user.email}, #{@user.name}"
  end

  def htmlbody
    body = '<table>'
    table_rows.each do |key, value|
      body += "<tr><th>#{key}</th><td>#{value}</td></tr>"
    end
    body += '</table>'
  end

  def table_rows
    [['Id', @user.id],
     ['First name', @user.first_name],
     ['Last name', @user.last_name],
     ['Email Address', @user.email],
     ['Country_or_Region', @country_region],
     ['Signed Up Via', @signed_up_via]]
  end
end
