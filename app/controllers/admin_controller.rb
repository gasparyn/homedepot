class AdminController < ApplicationController
  before_filter :authorize
  helper_method :is_admin?
  
  def index
    if current_user.is_store_admin?
      @total_orders = Order.count
      
    elsif current_user.is_employee_admin?
       @total_orders = Order.count
    elsif current_user.is_employee_delivery?
       @total_orders = Order.count  - 20
    end
  end
end
