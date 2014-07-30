module PageResourcesHelper
  def formatted_time(time_string=nil)
    time_string ||= cms_page_content(:time)
    Time.parse(time_string).strftime("%d %B %Y")
  end

  def about_us_page
    @about_us_page ||= Cms::Page.find_by_slug('about-us')
  end

  def news_page
    @news_page ||= Cms::Page.find_by_slug('news')
  end

  def datasets_page
    @datasets_page ||= Cms::Page.find_by_slug('resources-and-data')
  end

  def employees_page
    @employees_page ||= Cms::Page.find_by_slug('employees')
  end
  
  def expertise_page
    @expertise_page ||= Cms::Page.find_by_slug('expertise')
  end

end
