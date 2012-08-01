class SessionsController < ApplicationController
  skip_before_filter :authorize
  
  
  def new
  end

  def create
    if user = User.authenticate(params[:name],params[:password])
      session[:user_id] = user.id
      if user.role_id > 0
        redirect_to admin_url
      else
         redirect_to store_url
       end
    else
      redirect_to login_url, :alert => "Invalid user/password combination"
    end
  end
  
 

  def destroy
     user = User.find_by_id(session[:user_id])
     session[:user_id] = nil
      if user.role_id > 0
         redirect_to admin_login_url, :notice => "Logged Out"
       else
         redirect_to login_url, :notice => "Logged Out" 
      end
     end 
     
     
end
