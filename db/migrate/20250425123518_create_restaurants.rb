class CreateRestaurants < ActiveRecord::Migration[6.1]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.integer :restaurant_id
      t.string :address
      t.integer :owner_id

      t.timestamps
    end
  end
end
