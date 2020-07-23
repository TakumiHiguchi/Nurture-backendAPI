class CreateUserDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :user_details do |t|
      t.integer :user_id
      t.string :name
      t.integer :grade

      t.timestamps
    end
  end
end
