class User < ActiveRecord::Base
  ROLES = %w[user admin]

  attr_accessible :username, :email, :role, :stock_ids, :password_confirmation, :password

  has_and_belongs_to_many :stocks
  has_many :stock_items

  validates_uniqueness_of :username

  acts_as_authentic

  scope :sorted, order("username")

  def admin?
    role == "admin"
  end

  def stock_names
    stocks.sorted.collect {|stock| stock.name }.join(", ")
  end

  def stocks_for_select
    stocks.sorted.collect{|stock| [stock.name, stock.id]}
  end
end

