class DestroyAllOrphanForms < ActiveRecord::Migration
  def change
    Form.joins("LEFT JOIN comfy_cms_pages ccp ON ccp.id = forms.vacancy_id")
      .where("ccp.id IS NULL").destroy_all
  end
end
