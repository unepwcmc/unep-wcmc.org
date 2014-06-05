class Cms::PageObserver < ActiveRecord::Observer
  def before_destroy(page)
    destroy_employments_for(page)
  end

  def before_save(page)
    replaceHashtags(page)
  end

  private

  def destroy_employments_for(page)
    if employee?(page)
      Employment.destroy_for_employee(page)
    elsif featured_project?(page)
      Employment.destroy_for_project(page)
    end
  end

  def employee?(page)
    page.site.identifier == 'employees'
  end

  def featured_project?(page)
    page.site.identifier == 'featured-projects'
  end

  def replaceHashtags(page)
    i = page.blocks_attributes.index {|b| b[:identifier] == 'twitter_share_text' }
    if i 
      page.blocks_attributes[i][:content].gsub! '#', '%23'
    end
  end
end
