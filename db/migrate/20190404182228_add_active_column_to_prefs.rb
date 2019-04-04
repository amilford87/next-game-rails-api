class AddActiveColumnToPrefs < ActiveRecord::Migration[5.2]
  def change
    add_column :timeprefs, :active, :boolean
  end
end
