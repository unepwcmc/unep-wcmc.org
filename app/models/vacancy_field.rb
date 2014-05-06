class VacancyField < ActiveRecord::Base
  belongs_to :vacancy, class_name: "Cms::Page"

  has_attached_file :file

  def self.for_vacancy(vacancy)
    where(vacancy_id: vacancy.id)
  end

  def self.destroy_for_vacancy(vacancy)
    for_vacancy(dataset).destroy_all
  end

  def custom_label
    @custom_label
  end

  def removed
    @removed
  end
end
