FactoryGirl.define do
  factory :cms_layout, class: Cms::Layout do
    label "label"
    identifier "some-layout"
  end
end
