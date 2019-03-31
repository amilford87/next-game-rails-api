class CreateJoinTableSportFacility < ActiveRecord::Migration[5.2]
  def change
    create_join_table :sports, :facilities do |t|
      # t.index [:sport_id, :facility_id]
      # t.index [:facility_id, :sport_id]
    end
  end
end
