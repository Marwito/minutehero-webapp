FactoryGirl.define do
  factory :call do
    title 'My Call'
    dial_in '+34915513245'
    participant_code 'CODE'
    date_time '2017-01-10 13:24:08'
    user nil
  end
end
