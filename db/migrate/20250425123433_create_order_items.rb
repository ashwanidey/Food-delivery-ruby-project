class CreateOrderItems < ActiveRecord::Migration[6.1]
  def change
    create_table :order_items do |t|
      t.integer :menu_item_id
      t.integer :order_id
      t.integer :quantity
      t.string :price

      t.timestamps
    end
  end
end
