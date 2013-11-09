class CreateDocumentItems < ActiveRecord::Migration
  def self.up
    create_table :document_items do |t|
      t.references :document, :null => false
      t.references :equipment, :null => false
      t.float :quantity, :null => false, :default => 0.0
      t.timestamps
    end
    add_index :document_items, ["document_id"]
  end

  def self.down
    drop_table :document_items
  end
end

