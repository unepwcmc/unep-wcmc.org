FactoryGirl.define do
  factory :cms_layout, class: Comfy::Cms::Layout do
    label "label"
    identifier "some-layout"
  end

  factory :vacancies_layout, class: Comfy::Cms::Layout do
    label "vacancies-layout"
    identifier "vacancies-layout"
  end
end
