class Programme < ActiveRecord::Base
  has_many :employments, dependent: :destroy
  has_many :employees, through: :employments, class_name: "Cms::Page"
  has_many :subprogrammes, foreign_key: "parent_programme_id", class_name: "Programme"
  accepts_nested_attributes_for :subprogrammes

  validate :parent_programme_cant_be_a_subprogramme

  def has_employees?
    employees.present? || subprogrammes.any? { |s| s.has_employees? }
  end

  private

  def parent_programme_cant_be_a_subprogramme
    if parent_programme_id && Programme.find(parent_programme_id).parent_programme_id
      errors.add(:parent_programme_id, "is a subprogramme and can not be a parent programme")
    end
  end
end
