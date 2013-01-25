class CertificationsController < ApplicationController
  load_and_authorize_resource :certification
  load_and_authorize_resource :user, :through => :certification
  before_filter :authenticate_user!

  # GET /certifications
  # GET /certifications.json
  def index
    @certifications = @certifications.sort_by(&:name)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @certifications }
    end
  end

  # GET /certifications/1
  # GET /certifications/1.json
  def show
    @certification_users = []

    #TODO: make a better SQL query for this
    @certification.users.each do |user|
      @certification_users.push user if can? :read, user
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @certification }
    end
  end

  # GET /certifications/new
  # GET /certifications/new.json
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @certification }
    end
  end

  # GET /certifications/1/edit
  def edit
  end

  # POST /certifications
  # POST /certifications.json
  def create
    respond_to do |format|
      if @certification.save
        format.html { redirect_to Certification, :notice => 'Certification was successfully created.' }
        format.json { render :json => @certification, :status => :created, :location => @certification }
      else
        format.html { render :action => "new" }
        format.json { render :json => @certification.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /certifications/1
  # PUT /certifications/1.json
  def update
    respond_to do |format|
      if @certification.update_attributes(params[:certification])
        format.html { redirect_to Certification, :notice => 'Certification was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @certification.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /certifications/1
  # DELETE /certifications/1.json
  def destroy
    @certification.destroy

    respond_to do |format|
      format.html { redirect_to certifications_url }
      format.json { head :no_content }
    end
  end
end
