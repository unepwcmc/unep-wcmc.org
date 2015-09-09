# Uses slow helper methods. If we want to use this again,
# we need to use our own (see ApplicationHelper).

json.array! pages do |page|
  if cms_block_content(:thumbnail, page)
    json.thumbnail_url cms_block_content(:thumbnail, page).file.url
  else
    json.thumbnail_url ""
  end
  json.project_url @cms_site.path + page.full_path
  json.project_name cms_block_content(:project_name, page)
  json.description cms_block_content(:short_description, page)
end
