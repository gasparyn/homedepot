class Order < ActiveRecord::Base
  attr_accessible :address, :email, :name, :pay_method
  
  PAYMENT_TYPES =["Check","Credit Card", "Paypal","Purchase Order"]
  
  validates :name, :address, :email, :pay_method, :presence => true
  validates :pay_method, :inclusion => PAYMENT_TYPES
  validates_format_of :email, :with => /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i

  has_many :line_items, :dependent => :destroy
  
  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items<<item
    end
  end
end
