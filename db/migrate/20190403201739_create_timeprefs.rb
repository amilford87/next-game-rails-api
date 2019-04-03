class CreateTimeprefs < ActiveRecord::Migration[5.2]
  def change
    create_table :timeprefs do |t|
      t.integer :week_day
      t.time :start_time
      t.time :end_time
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
