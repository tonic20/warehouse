class StockItem < ActiveRecord::Base
  DOC_TYPES = { :income => 0,
    :outcome => 1,
    #:movement => 2,
  }

  attr_accessible :doc_type, :stock_date, :user_id, :stock_id, :equipment_id, :quantity, :stock_target_id

  belongs_to :user
  belongs_to :stock
  belongs_to :stock_target, :class_name => "Stock"
  belongs_to :equipment

  validates_presence_of :doc_type
  validates_presence_of :stock_date
  validates_presence_of :user_id
  validates_presence_of :stock_id
  validates_presence_of :equipment_id
  validates_presence_of :quantity

  scope :sorted, order("stock_date desc, created_at desc")

  scope :by_equipment, lambda { |equipment_id, date_from, date_to|
    where(:equipment_id => equipment_id).
    where("stock_date BETWEEN :date_from AND :date_to", :date_from => date_from, :date_to => date_to).
    includes(:stock).
    order("stock_date desc, created_at desc")
  }

  scope :by_equipment_and_stock, lambda { |equipment_id, stock_id, date_from, date_to|
    where(:equipment_id => equipment_id).
    where(:stock_id => stock_id).
    where("stock_date BETWEEN :date_from AND :date_to", :date_from => date_from, :date_to => date_to).
    includes(:stock).
    order("stock_date desc, created_at desc")
  }

  scope :by_stock, lambda { |stock, date_from, date_to|
    where(:stock_id => stock.id).
    where("stock_date BETWEEN :date_from AND :date_to", :date_from => date_from, :date_to => date_to).
    order("stock_date desc, created_at desc")
  }

  scope :by_date, lambda { |date_from, date_to|
    where("stock_date BETWEEN :date_from AND :date_to", :date_from => date_from, :date_to => date_to).
    order("stock_date desc, created_at desc")
  }

  def doc_type_text
    I18n.t("doc_types.#{DOC_TYPES.index(doc_type)}")
  end

  def self.doc_types_for_select
    DOC_TYPES.collect{|key, val| [I18n.t("doc_types.#{key}"), val]}
  end

  def income?
    doc_type == DOC_TYPES[:income]
  end

  def outcome?
    doc_type == DOC_TYPES[:outcome]
  end

  def sign
    case doc_type
      when DOC_TYPES[:income]
        "+"
      when DOC_TYPES[:outcome]
        "-"
    end
  end

  def quantity_with_units
    case Equipment::UNITS.index(equipment.units)
    when :pieces
      "#{quantity.to_i} #{equipment.units_text}"
    else
      "#{quantity} #{equipment.units_text}"
    end if equipment
  end
end

