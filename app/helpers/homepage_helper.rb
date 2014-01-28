module HomepageHelper
  def name_for_back_link
    if request.referrer == cms_render_html_url
      "Back to Home"
    else
      "Back to News Archive"
    end
  end
end
