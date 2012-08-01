class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authorize

  def current_user
    current_user = User.find(session[:user_id]) if !session[:user_id].nil?
  end
  
  
  private
  
  def current_cart
    Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
    cart = Cart.create
    session[:cart_id] = cart.id
    cart
  end


  def authorize
    user = User.find_by_id(session[:user_id])
    unless user && user.role_id > 0
      #session[:user_id] = nil
      redirect_to login_url, :notice =>"Please Log In"
    end
  end
end
