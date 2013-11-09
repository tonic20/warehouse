class Stock < ActiveRecord::Base
  attr_accessible :name

  has_and_belongs_to_many :users
  has_many :stock_items

  validates_presence_of :name

  scope :sorted, order("name")

  def equipments_for_select
    o = Equipment.find_by_sql([%Q{
          SELECT e.id, name
          FROM equipment e
          LEFT JOIN stock_items s ON s.equipment_id = e.id
          WHERE stock_id = :stock_id
          GROUP BY equipment_id, name
          ORDER BY name
        }, {:stock_id => id}
      ]).collect{|e| [e.name, e.id]}
    [['', nil]] + o
  end
end

