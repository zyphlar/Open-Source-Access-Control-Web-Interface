class UserCertificationsController < ApplicationController
  # GET /user_certifications
  # GET /user_certifications.json
  def index
    @user_certifications = UserCertification.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @user_certifications }
    end
  end

  # GET /user_certifications/1
  # GET /user_certifications/1.json
  def show
    @user_certification = UserCertification.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @user_certification }
    end
  end

  # GET /user_certifications/new
  # GET /user_certifications/new.json
  def new
    @user_certification = UserCertification.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @user_certification }
    end
  end

  # GET /user_certifications/1/edit
  def edit
    @user_certification = UserCertification.find(params[:id])
  end

  # POST /user_certifications
  # POST /user_certifications.json
  def create
    @user_certification = UserCertification.new(params[:user_certification])

    respond_to do |format|
      if @user_certification.save
        format.html { redirect_to @user_certification, :notice => 'User certification was successfully created.' }
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
    @user_certification = UserCertification.find(params[:id])

    respond_to do |format|
      if @user_certification.update_attributes(params[:user_certification])
        format.html { redirect_to @user_certification, :notice => 'User certification was successfully updated.' }
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
    @user_certification = UserCertification.find(params[:id])
    @user_certification.destroy

    respond_to do |format|
      format.html { redirect_to user_certifications_url }
      format.json { head :no_content }
    end
  end
end
