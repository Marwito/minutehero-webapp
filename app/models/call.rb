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
end
