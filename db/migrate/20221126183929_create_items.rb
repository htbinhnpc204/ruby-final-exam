class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :item_name
      t.integer :item_qty
      t.string :item_des

      t.timestamps
    end
  end
end
