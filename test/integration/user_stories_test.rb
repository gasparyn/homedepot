require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
  fixtures :products
  LineItem.delete_all
  Order.delete_all
  product = products(:one)
  
  #user goes to the store main page
  get '/'
  assert_response :success
  assert_template "index"
  
  #user selects a product and adds it to his shopping cart
  xml_http_request :post, '/line_items', :product_id =>product.id
  assert_response :success
  
  cart = Cart.find(session[:cart_id])
  assert_equal 1, cart.line_items.size
  assert_equal product, cart.line_items[0].product
  
  #Then the user checks it out
  get "/orders/new"
  assert_response :success
  assert_template "new"
  
  #user fills the detail form for check out and payment method
  post_via_redirect "/orders", :order =>{:name => "John Doe",
                                         :address => "123 South Street",
                                         :email =>"gas@gas.com",
                                         :pay_method => "Check" }
  assert_response :success
  assert_template "index"
  cart = Cart.find(session[:cart_id])
  assert_equal 0, cart.line_items.size
  
  #check database to ensure we just have one order since we cleared database
  
  orders = Order.all
  assert_equal 1, orders.size
  order = orders[0]  
  
  assert_equal "John Doe", order.name
  assert_equal "123 South Street", order.address
  assert_equal "gas@gas.com", order.email
  assert_equal "Check", order.pay_method
  
  #verify that the mail is correctly addressed and has the expected subject line
  mail = ActionMailer::Base.deliveries.last
  assert_equal "kenyangas@gmail.com", mail.to
  assert_equal "kenyangas@gmail.com",mail[:from].value
  assert_equal 'Bookstore Order Confirmation', mail.subject
  
end
