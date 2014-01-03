FactoryGirl.define do
  factory :text_field_submission do
    form_submission_id 1
    field_id 1
    type "Text"
    content "MyText"
  end
end
