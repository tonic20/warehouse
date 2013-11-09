class CreateStocksUsers < ActiveRecord::Migration
  def self.up
    create_table :stocks_users, :id => false do |t|
      t.references :user
      t.references :stock
    end
    add_index :stocks_users, ["stock_id", "user_id"], :unique => true
  end

  def self.down
    drop_table :stocks_users
  end
end

