class Request < ApplicationRecord
  validates :from, :subject, :content, presence: true
end
