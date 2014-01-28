module Admin::EditionsHelper
  def edition_for(resource)
    @editions.select { |e| e.resource_id == resource.id }.first
  end
end
