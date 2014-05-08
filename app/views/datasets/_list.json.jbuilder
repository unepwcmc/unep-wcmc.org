json.datasets Cms::Site.find_by_identifier('resources-and-data').pages.root.children.published.includes(blocks: [:files]).each do |dataset|
  json.title block_content(:title, dataset)
  json.content block_content(:content, dataset)
  json.id dataset.id
  json.slug dataset.slug
  json.publication_date block_content(:publication_date, dataset)
  json.publication_date_year block_content(:publication_date_display_only_year, dataset)
  json.content_type block_content(:content_type, dataset)
  json.first_link block_content(:first_url, dataset)
  json.first_link_label block_content(:first_url_label, dataset)
  json.second_link block_content(:second_url, dataset)
  json.second_link_label block_content(:second_url_label, dataset)
  json.author block_content(:author, dataset)
  json.isbn block_content(:isbn, dataset)
  if !page_files(:file, dataset).empty?
    json.file_url page_files(:file, dataset)[0].file.url
  end
end
json.content_types ContentType.all do |content_type|
  json.plural content_type.plural
  json.singular content_type.singular
end
json.query_slug @cms_page
