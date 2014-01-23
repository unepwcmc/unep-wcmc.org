module PageResourcesHelper
  def formatted_time(time_string=nil)
    time_string ||= cms_page_content(:time)
    Time.parse(time_string).strftime("%d %B %Y")
  end
end
