json.datasets @cms_page.children.published.each do |dataset|
  json.title cms_page_content(:title, dataset)
  json.content cms_page_content(:content, dataset)
  json.publication_date cms_page_content(:publication_date, dataset)
  json.content_type cms_page_content(:content_type, dataset)
end
json.content_types ContentType.all do |content_type|
  json.plural content_type.plural
  json.singular content_type.singular
end
