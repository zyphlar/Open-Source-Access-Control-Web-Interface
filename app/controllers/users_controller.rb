class UsersController < ApplicationController
<<<<<<< HEAD
  # GET /users
  # GET /users.json
  def index
    @users = User.all
=======
  load_and_authorize_resource
  before_filter :authenticate_user!
  
  # GET /users
  # GET /users.json
  def index
    #@users = User.all
    #authorize! :read, @users
>>>>>>> 03d99741e5b661e63f6281115d2db333082a09b1

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
<<<<<<< HEAD
    @user = User.find(params[:id])
=======
    #@user = User.find(params[:id])
>>>>>>> 03d99741e5b661e63f6281115d2db333082a09b1

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @user }
    end
  end

  # PUT /users/1/upload
  def upload
<<<<<<< HEAD
    @user = User.find(params[:id])
=======
    #@user = User.find(params[:id])
>>>>>>> 03d99741e5b661e63f6281115d2db333082a09b1
    @upload_result = @user.upload_to_door

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @upload_result }
    end
  end

  # PUT /users/upload_all
  def upload_all
    @upload_result = User.upload_all_to_door

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @upload_result }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
<<<<<<< HEAD
    @user = User.new
=======
    #@user = User.new
>>>>>>> 03d99741e5b661e63f6281115d2db333082a09b1

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @user }
    end
  end

  # GET /users/1/edit
  def edit
<<<<<<< HEAD
    @user = User.find(params[:id])
=======
    #@user = User.find(params[:id])
>>>>>>> 03d99741e5b661e63f6281115d2db333082a09b1
  end

  # POST /users
  # POST /users.json
  def create
<<<<<<< HEAD
    @user = User.new(params[:user])
=======
    #@user = User.new(params[:user])
>>>>>>> 03d99741e5b661e63f6281115d2db333082a09b1

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, :notice => 'User was successfully created.' }
        format.json { render :json => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
<<<<<<< HEAD
    @user = User.find(params[:id])
=======
    #@user = User.find(params[:id])
>>>>>>> 03d99741e5b661e63f6281115d2db333082a09b1

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, :notice => 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
<<<<<<< HEAD
    @user = User.find(params[:id])
=======
    #@user = User.find(params[:id])
>>>>>>> 03d99741e5b661e63f6281115d2db333082a09b1
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
end
