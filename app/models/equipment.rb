class Equipment < ActiveRecord::Base
  UNITS = {
    :pieces => 0,
    :kg => 1,
    :meter => 2,
  }

  attr_accessible :name, :part_number, :category_id, :units

  belongs_to :category
  has_many :stock_items, :dependent => :destroy

  validates_presence_of :name
  validates_presence_of :units
  validates_presence_of :category_id

  scope :sorted, order("name")

  def self.units_for_select
    UNITS.collect{|key, val| [I18n.t("units.#{key}"), val]}
  end

  def units_text
    I18n.t("units.#{UNITS.index(units)}")
  end

  def self.equipment_summary(category_id, date_from, date_to)
    if category_id
      category_ids = [category_id]
    else
      category_ids = Category.all.collect(&:id)
    end
    Equipment.find_by_sql([%Q{
      SELECT e2.id, e2.name, units, qty_income, qty_outcome, c.name category_name
      FROM
          (SELECT e.id, name, units, qty_income, category_id
           FROM equipment e
             LEFT JOIN (SELECT equipment_id, sum(quantity) qty_income
                      FROM stock_items
                      WHERE doc_type = 0 AND stock_date BETWEEN :date_from AND :date_to
                      GROUP BY equipment_id) st_in ON st_in.equipment_id = e.id
           WHERE category_id IN (:category_ids)
          ) e2
        LEFT JOIN (SELECT equipment_id, sum(quantity) qty_outcome
                 FROM stock_items
                 WHERE doc_type = 1 AND stock_date <= :date_to
                 GROUP BY equipment_id) st_out ON st_out.equipment_id = e2.id,
        categories c
      WHERE c.id = e2.category_id
      ORDER BY name
      }, {:category_ids => category_ids, :date_from => date_from, :date_to => date_to}
    ])
  end

  def self.equipment_by_stock(stock_id, category_id, date_from, date_to)
    if category_id
      category_ids = [category_id]
    else
      category_ids = Category.all.collect(&:id)
    end
    Equipment.find_by_sql([%Q{
        SELECT e2.id, e2.name, units, qty_income, qty_outcome, c.name category_name
        FROM
          (SELECT e.id, name, units, qty_income, category_id
           FROM equipment e
             LEFT JOIN (SELECT equipment_id, sum(quantity) qty_income
                        FROM stock_items
                        WHERE doc_type = 0 AND stock_id = :stock_id AND stock_date BETWEEN :date_from AND :date_to
                        GROUP BY equipment_id) st_in ON st_in.equipment_id = e.id
           WHERE e.category_id IN (:category_ids)
           ) e2
           LEFT JOIN (SELECT equipment_id, sum(quantity) qty_outcome
                      FROM stock_items
                      WHERE doc_type = 1 AND stock_id = :stock_id AND stock_date BETWEEN :date_from AND :date_to
                      GROUP BY equipment_id) st_out
           ON st_out.equipment_id = e2.id,
           categories c
        WHERE c.id = e2.category_id
        ORDER BY e2.name
        }, {:stock_id => stock_id, :category_ids => category_ids, :date_from => date_from, :date_to => date_to}
      ])
  end
end

