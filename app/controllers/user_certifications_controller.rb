class UserCertificationsController < ApplicationController
  load_and_authorize_resource :user_certification
  #load_and_authorize_resource :user, :through => :user_certification
  #load_and_authorize_resource :certification, :through => :user_certification
  before_filter :authenticate_user!

  # Load users and certs based on current ability
  before_filter :only => [:new, :edit, :create, :update] do
    @users = User.where(:hidden => [false,nil]).accessible_by(current_ability).sort_by(&:name)
    @certifications = Certification.accessible_by(current_ability).sort_by(&:name)
  end
  
  # GET /user_certifications
  # GET /user_certifications.json
  def index
    @grouped_user_certs = @user_certifications.group_by { |uc| uc.certification }

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @user_certifications }
    end
  end

  # GET /user_certifications/1
  # GET /user_certifications/1.json
  def show
    @created_by = User.find(@user_certification.created_by) unless @user_certification.created_by.blank?
    @updated_by = User.find(@user_certification.updated_by) unless @user_certification.updated_by.blank?

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @user_certification }
    end
  end

  # GET /user_certifications/new
  # GET /user_certifications/new.json
  def new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @user_certification }
    end
  end

  # GET /user_certifications/1/edit
  def edit
  end

  # POST /user_certifications
  # POST /user_certifications.json
  def create
    #Log who created this
    @user_certification.created_by = current_user.id

    respond_to do |format|
      if @user_certification.save
        format.html { redirect_to UserCertification, :notice => 'User certification was successfully created.' }
        format.json { render :json => @user_certification, :status => :created, :location => @user_certification }
      else
        format.html { render :action => "new" }
        format.json { render :json => @user_certification.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /user_certifications/1
  # PUT /user_certifications/1.json
  def update
    #Log who updated this
    @user_certification.updated_by = current_user.id

    respond_to do |format|
      if @user_certification.update_attributes(params[:user_certification])
        format.html { redirect_to UserCertification, :notice => 'User certification was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @user_certification.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /user_certifications/1
  # DELETE /user_certifications/1.json
  def destroy
    @user_certification.destroy

    respond_to do |format|
      format.html { redirect_to user_certifications_url }
      format.json { head :no_content }
    end
  end
end
