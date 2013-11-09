class DatabaseRefactored < ActiveRecord::Migration
  def self.up
    drop_table :document_items
    drop_table :documents
  end

  def self.down
    create_table :document_items do |t|
      t.references :document, :null => false
      t.references :equipment, :null => false
      t.float :quantity, :null => false, :default => 0.0
      t.timestamps
    end
    add_index :document_items, ["document_id"]

    create_table :documents do |t|
      t.references :user, :null => false
      t.references :stock, :null => false
      t.timestamps
    end
  end
end

