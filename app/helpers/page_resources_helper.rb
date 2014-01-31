module PageResourcesHelper
  def formatted_time(time_string=nil)
    time_string ||= cms_page_content(:time)
    Time.parse(time_string).strftime("%d %B %Y")
  end

  def about_us_page
    @about_us_page ||= Cms::Site.find_by_identifier('about-us').pages.root
  end
end
