class Call < ApplicationRecord
  belongs_to :user
  validates :dial_in, :participant_code, :date_time, :user_id, presence: true
  validate do
    # normalizer = PhoneNormalizer.new(attributes['dial_in'])
    # if attributes['dial_in'].blank? ||
    #     !normalizer.valid?
    # phone number between 6 - 15
    unless !dial_in.blank? && dial_in.length.between?(9, 18)
      errors.add(:dial_in, I18n.t('phones.errors.invalid'))
    end
  end

  validate do
    errors.add :date_time, I18n.t('call.errors.date_time.past') if past?
  end

  include TableFilters
  columns_filtered :title, :participant_code, 'users.first_name', 'users.last_name'

  scope :most_recent, -> { where('date_time < ?', Time.now).order(:date_time) }
  scope :upcoming, -> { where('date_time > ?', Time.now).order(:date_time) }
  scope :past, -> { where('date_time < ?', Time.now).order(:date_time) }

  def past?
    Time.zone = time_zone
    Time.zone.now > date_time if date_time
  end
end
