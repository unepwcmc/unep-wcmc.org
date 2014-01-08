# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :submission do
    form_id 1
    slug "MyString"
    email "someone@example.com"
  end
end
