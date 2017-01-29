FactoryGirl.define do
  factory :call do
    title 'My Call'
    dial_in '+34915513245'
    participant_code 'CODE'
    date_time { Time.now + 2.days }
    time_zone 'Berlin'
    before(:create) do |d|
      d.user = create :user unless d.user
    end
  end
end
