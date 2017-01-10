FactoryGirl.define do
  factory :call do
    title 'My Call'
    dial_in '+346666060'
    participant_code 'CODE'
    date_time '2017-01-10 13:24:08'
    user nil
  end
end
