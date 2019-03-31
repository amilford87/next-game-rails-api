class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.date :date
      t.timetz :start_time
      t.references :facility, foreign_key: true
      t.references :sport, foreign_key: true

      t.timestamps
    end
  end
end
