class UsersController < ApplicationController
  load_and_authorize_resource
  before_filter :authenticate_user!

  # GET /users
  # GET /users.json
  def index
    case params[:sort]
    when "name"
      @users = @users.sort_by(&:name)
    when "certifications"
      @users = @users.sort_by{ |u| [-u.certifications.count,u.name] }
    when "orientation"
      @users = @users.sort_by{ |u| [-u.orientation.to_i,u.name] }
    when "waiver"
      @users = @users.sort_by{ |u| [-u.waiver.to_i,u.name] }
    when "member"
      @users = @users.sort_by{ |u| [-u.member.to_i,-u.member_level.to_i,u.name] }
    when "card"
      @users = @users.sort_by{ |u| [-u.cards.count,u.name] }
    when "instructor"
      @users = @users.sort{ |a,b| [b.instructor.to_s,a.name] <=> [a.instructor.to_s,b.name] }
    when "admin"
      @users = @users.sort{ |a,b| [b.admin.to_s,a.name] <=> [a.admin.to_s,b.name] }
    else
      @users = @users.sort_by(&:name)
    end


    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @user }
    end
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    respond_to do |format|
      if @user.save
        format.html { redirect_to users_url, :notice => 'User was successfully created.' }
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
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to users_url, :notice => 'User was successfully updated.' }
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
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, :notice => 'User successfully deleted.' }
      format.json { head :no_content }
    end
  end
end
