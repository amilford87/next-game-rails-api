class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password_digest
      t.string :image
      t.boolean :pref_basketball
      t.boolean :pref_volleyball
      t.boolean :pref_soccer
      t.boolean :pref_tennis
      t.boolean :pref_frisbee

      t.timestamps
    end
  end
end
