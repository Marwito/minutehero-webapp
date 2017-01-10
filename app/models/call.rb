class Call < ApplicationRecord
  belongs_to :user
  validates :dial_in, :participant_code, :date_time, :user, presence: true
end
