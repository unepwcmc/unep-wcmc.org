module PageResourcesHelper
  def formatted_time(time_string=nil)
    time_string ||= cms_page_content(:time)
    Time.parse(time_string).strftime("%d %B %Y")
  end

  def about_us_page
    @about_us_page ||= Cms::Site.find_by_identifier('about-us').pages.root
  end

  def news_page
    @news_page ||= Cms::Site.find_by_identifier('news').pages.root
  end

  def datasets_page
    @datasets_page ||= Cms::Site.find_by_identifier('resources-and-data').pages.root
  end

  def employees_page
    @employees_page ||= Cms::Site.find_by_identifier('employees').pages.root
  end
  
  def expertise_page
    @expertise_page ||= Cms::Site.find_by_identifier('expertise').pages.root
  end

  def wcmc_page
    @wcmc_page ||= Cms::Site.find_by_identifier('wcmc').pages.root
  end

end
