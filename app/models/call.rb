class Call < ApplicationRecord
  belongs_to :user
  validates :dial_in, :participant_code, :date_time, :user, presence: true
  validate do
    normalizer = PhoneNormalizer.new(attributes['dial_in'])
    if attributes['dial_in'].blank? ||
        !normalizer.valid?
      errors.add(:dial_in, normalizer.error)
    end
  end

  validate do
    errors.add :date_time, I18n.t('call.errors.date_time.past') if past?
  end

  scope :quick_search, lambda { |keyword|
    where 'lower(title) like :wildcard_kb OR ' \
          'lower(participant_code) like :wildcard_kb',
          wildcard_kb: "%#{keyword.to_s.downcase}%"
  }

  def past?
    Time.zone = time_zone
    Time.zone.now > date_time if date_time
  end
end
