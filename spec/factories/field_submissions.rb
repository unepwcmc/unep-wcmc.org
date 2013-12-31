# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :field_submission do
    field_id 1
    form_submission 1
    type ""
    content "MyText"
  end
end
