class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table :documents do |t|
      t.references :user, :null => false
      t.references :stock, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :documents
  end
end

