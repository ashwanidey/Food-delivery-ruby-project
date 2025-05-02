class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.integer :restaurant_id
      t.string :description
      t.string :name
      t.integer :price
      t.string :category

      t.timestamps
    end
  end
end
