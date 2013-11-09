class Category < ActiveRecord::Base
  attr_accessible :name
  has_many :equipments
  validates_presence_of :name

  scope :sorted, order("name")

  def self.for_select
    [['', nil]] + Category.sorted.collect{|c| [c.name, c.id]}
  end
end

