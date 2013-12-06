json.array! pages do |page|
  if cms_page_content(:thumbnail, page)
    json.thumbnail_url cms_page_content(:thumbnail, page).file.url
  else
    json.thumbnail_url ""
  end
  json.project_url @cms_site.path + page.full_path
  json.project_name cms_page_content(:project_name, page)
  json.description cms_page_content(:short_description, page)
end
