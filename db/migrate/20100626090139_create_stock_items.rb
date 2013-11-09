class CreateStockItems < ActiveRecord::Migration
  def self.up
    create_table :stock_items do |t|
      t.date :stock_date, :null => false
      t.references :user, :null => false
      t.references :stock, :null => false
      t.integer :stock_target_id
      t.references :equipment, :null => false
      t.float :quantity, :null => false
      t.integer :doc_type, :null => false, :default => 0
      t.timestamps
    end
    add_index :stock_items, ["stock_id", "equipment_id"]
  end

  def self.down
    drop_table :stock_items
  end
end

