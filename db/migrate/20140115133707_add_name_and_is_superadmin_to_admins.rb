class AddNameAndIsSuperadminToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :name, :string
    add_column :admins, :is_superadmin, :boolean
  end
end
