FactoryGirl.define do
  factory :programme do
  end

  trait :with_employee do
    after(:create) do |programme|
      programme.employments.create(employee: create(:employee))
    end
  end
end
