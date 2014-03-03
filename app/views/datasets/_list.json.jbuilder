json.datasets Cms::Site.find_by_identifier('resources-and-data').pages.root.children.published.each do |dataset|
  json.title cms_page_block_content(:title, dataset)
  json.content cms_page_block_content(:content, dataset)
  json.id dataset.id
  json.slug dataset.slug
  json.publication_date cms_page_block_content(:publication_date, dataset)
  json.content_type cms_page_block_content(:content_type, dataset)
  json.first_link cms_page_block_content(:first_url, dataset)
  json.first_link_label cms_page_block_content(:first_url_label, dataset)
  json.second_link cms_page_block_content(:second_url, dataset)
  json.second_link_label cms_page_block_content(:second_url_label, dataset)
  json.author cms_page_block_content(:author, dataset)
  json.isbn cms_page_block_content(:isbn, dataset)
  if !cms_page_files(:file, dataset).empty?
    json.file_url cms_page_content(:file, dataset).file.url
  end
end
json.content_types ContentType.all do |content_type|
  json.plural content_type.plural
  json.singular content_type.singular
end
