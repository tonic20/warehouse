class AddUnitsToEquipment < ActiveRecord::Migration
  def self.up
    add_column :equipment, :units, :integer, :default => 0
  end

  def self.down
    remove_column :equipment, :units
  end
end

