module SessionsHelper
  
  def logged_in?
    !current_user.nil?
  end
  
  def logged_in_as_admin?
    !current_user.nil? && current_user.role_id == 1
  end
  
  def current_user=(user)
    @current_user = user
  end
 
  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end
  
  
end
