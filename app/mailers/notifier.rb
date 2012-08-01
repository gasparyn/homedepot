class Notifier < ActionMailer::Base
  default :from=> "admin@gasparobimba.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.order_received.subject
  #

    def order_received(order)
        @order         = order
        mail  :to      => "kenyangas@gmail.com", 
        #:cc           => "suyeb23@gmail.com",
              :subject => 'Bookstore Order Confirmation'
    end

      # Subject can be set in your I18n file at config/locales/en.yml
      # with the following lookup:
      #
      #   en.notifier.order_shipped.subject
      #
   def order_shipped(order)
        @order = order

        mail  :to => "kenyangas@gmail.com", 
              :cc => "suyeb23@gmail.com",
              :subject => 'Your Bookstore Order has been Shipped'    
  end 
end
