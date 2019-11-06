class CreateBells < ActiveRecord::Migration[6.0]
  def change
    create_table :bells do |t|
      t.string :place
      t.string :password
      t.text :note

      t.timestamps
    end
  end
end
