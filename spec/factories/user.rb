FactoryGirl.define do
 factory :user do
   sequence(:email){|n| "user#{n}@unep-wcmc.org"}
   name "Admin"
   password "test1234"
   password_confirmation "test1234"
   confirmed_at Time.now
   is_superadmin true
 end
end
