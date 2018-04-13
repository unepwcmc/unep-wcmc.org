# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :form do
    vacancy = FactoryGirl.create(:vacancy)
  end
end
