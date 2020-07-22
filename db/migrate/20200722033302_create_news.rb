class CreateNews < ActiveRecord::Migration[6.0]
  def change
    create_table :news do |t|
      t.string :title
      t.string :date
      t.string :link
      t.string :base_title
      t.string :base_link

      t.timestamps
    end
  end
end
