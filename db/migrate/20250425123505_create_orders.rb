class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.integer :foodie_id
      t.integer :restaurant_id
      t.integer :total_amount

      t.timestamps
    end
  end
end
