json.articles Comfy::Cms::Site.find_by_identifier('news').pages.root.children.published.includes(blocks: [:files]).each do |article|
  json.title block_content(:news_header, article)
  json.slug article.slug
  json.date block_content(:time, article)
  json.introduction block_content(:short_description, article)
end

json.query_slug @cms_page