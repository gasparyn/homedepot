class UsersController < ApplicationController
  # GET /users
  # GET /users.json
 skip_before_filter :authorize
  
  
  def index
    if current_user.is_store_admin?
      @users = User.order(:name)
      
      respond_to do |format|
        format.html # index.html.erb
        format.json { render :json => @users }
      end
    else
      respond_to do |format|
        format.html { redirect_to store_url, :notice => "The Page You Requested is Invalid!" }
      end
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show 
     @user = User.find(params[:id])
     if current_user.id == @user.id  ||current_user.is_store_admin?
       respond_to do |format|
         format.html # show.html.erb
         format.json { render :json => @user }
       end
    else
      respond_to do |format|
        format.html { redirect_to store_url, :notice => "The Page You Requested is Invalid!" }
      end
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @user }
    end
  end

  # GET /users/1/edit
  def edit
      @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save 
        #if the user is new to the site
        if !current_user
          format.html { redirect_to @user, :notice => "Your account was successfully created." }
          format.json { render :json => @user, :status => :created, :location => @user }
        #if the user is admin adding a user
        elsif current_user && current_user.is_admin? 
          format.html { redirect_to admin_users_url, :notice => "Added a new User: #{@user.name}" }
          format.json { render :json => @user, :status => :created, :location => @user }
        end
      else
        format.html { render :action => "new" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])
     if (current_user.id == @user.id) || current_user.is_admin? 
      respond_to do |format|
        if @user.update_attributes(params[:user])
          format.html { redirect_to @user, :notice => "User #{@user.name} was successfully updated." }
          format.json { head :no_content }
        else
          format.html { render :action => "edit" }
          format.json { render :json => @user.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    begin
      @user.destroy
      flsh[:notice] ="User #{user.name} : (#{user.role.name}) has been deleted"

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
end
end
