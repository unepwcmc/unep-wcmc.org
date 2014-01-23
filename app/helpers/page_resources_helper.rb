module PageResourcesHelper
  def formatted_time(time_string)
    Time.parse(time_string).strftime("%d %B %Y")
  end
end
