class Call < ApplicationRecord
  belongs_to :user
  validates :dial_in, :participant_code, :schedule_date, :schedule_time,
            :time_zone, :user_id, presence: true
  validate do
    # normalizer = PhoneNormalizer.new(attributes['dial_in'])
    # if attributes['dial_in'].blank? ||
    #     !normalizer.valid?
    # phone number between 6 - 15
    unless !dial_in.blank? && dial_in.length.between?(9, 18)
      errors.add(:dial_in, I18n.t('phones.errors.invalid'))
    end
  end

  include TableFilters
  columns_filtered :title, :participant_code,
                   'users.first_name', 'users.last_name'

  scope :most_recent, -> {
    where('(schedule_date + schedule_time) < ?', Time.now)
      .order(:schedule_date, :schedule_time)
  }
  scope :upcoming, -> {
    where('(schedule_date + schedule_time) > ?', Time.now)
      .order(:schedule_date, :schedule_time)
  }
  scope :past, -> {
    where('(schedule_date + schedule_time) < ?', Time.now)
      .order(:schedule_date, :schedule_time)
  }

  # rubocop:disable AbcSize
  def date_time
    if schedule_date && schedule_time && time_zone
      DateTime.new(schedule_date.year, schedule_date.month, schedule_date.day,
                   schedule_time.hour, schedule_time.min, schedule_time.sec,
                   time_zone).to_datetime
    end
  end

  def date_time=(value)
    self.schedule_date = value.to_date
    self.schedule_time = value.to_time
  end
end
