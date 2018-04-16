FactoryGirl.define do
  factory :cms_layout, class: Comfy::Cms::Layout do
    label "label"
    identifier "some-layout"
  end
end

FactoryGirl.define do
  factory :vacancies_layout, class: Comfy::Cms::Layout do
    label "vacancies-layout"
    identifier "vacancies"
  end
end
