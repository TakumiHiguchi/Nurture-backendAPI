class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :key
      t.string :session
      t.integer :maxAge
      
      t.timestamps
    end
  end
end
