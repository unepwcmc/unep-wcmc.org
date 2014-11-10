# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :submission do
    form_id 1
    slug "MyString"
    email "someone@example.com"
    content OpenStruct.new(
      uk_working_ability: true,
      last_salary: 0,
      benefits: 'n/a',
      interview_availability: 'yes',
      notice_period: '1 month'
      )
  end
end
