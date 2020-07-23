class CreateCalendars < ActiveRecord::Migration[6.0]
  def change
    create_table :calendars do |t|
      t.string :name
      t.text :description
      t.boolean :shareBool, default: false, null: false
      t.boolean :cloneBool, default: false, null: false
      t.string :key
      t.integer :author_id

      t.timestamps
    end
  end
end
