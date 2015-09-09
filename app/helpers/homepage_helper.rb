module HomepageHelper
  def name_for_back_link
    if request.referrer == comfy_cms_render_page_url
      "Back to Home"
    else
      "Back to News Archive"
    end
  end
end
