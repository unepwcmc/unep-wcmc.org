FactoryGirl.define do
  factory :cms_layout, class: Comfy::Cms::Layout do
    label "label"
    identifier "some-layout"
  end
end
