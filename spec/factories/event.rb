FactoryGirl.define do
  factory :today_event, class: Event do
    name 'Today event'
    date Date.today
  end

  factory :tomorrow_event, class: Event do
    name 'Tomorrow event'
    date Date.tomorrow
  end

  factory :yesterday_event, class: Event do
    name 'Yesterday event'
    date Date.yesterday
  end

  factory :visited_event, class: Event do
    name 'Visited event'
    date Date.today
    visited_flag true
  end
end
