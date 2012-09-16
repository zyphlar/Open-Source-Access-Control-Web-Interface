class DoorLogsController < ApplicationController
  authorize_resource
  before_filter :authenticate_user!

  # GET /door_logs
  # GET /door_logs.json
  def index
    @door_logs = DoorLog.find(:all, :order => "created_at DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @door_logs }
    end
  end

  # GET /door_logs/1
  # GET /door_logs/1.json
#  def show
#    @door_log = DoorLog.find(params[:id])
#
#    respond_to do |format|
#      format.html # show.html.erb
#      format.json { render :json => @door_log }
#    end
#  end

  # GET /door_logs/1
  # GET /door_logs/1.json
  def download
    @results = DoorLog.download_from_door

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @results }
    end
  end

#  # GET /door_logs/new
#  # GET /door_logs/new.json
#  def new
#    @door_log = DoorLog.new
#
#    respond_to do |format|
#      format.html # new.html.erb
#      format.json { render :json => @door_log }
#    end
#  end

  # GET /door_logs/1/edit
#  def edit
#    @door_log = DoorLog.find(params[:id])
#  end

  # POST /door_logs
  # POST /door_logs.json
#  def create
#    @door_log = DoorLog.new(params[:door_log])
#
#    respond_to do |format|
#      if @door_log.save
#        format.html { redirect_to @door_log, :notice => 'Door log was successfully created.' }
#        format.json { render :json => @door_log, :status => :created, :location => @door_log }
#      else
#        format.html { render :action => "new" }
#        format.json { render :json => @door_log.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

  # PUT /door_logs/1
  # PUT /door_logs/1.json
#  def update
#    @door_log = DoorLog.find(params[:id])
#
#    respond_to do |format|
#      if @door_log.update_attributes(params[:door_log])
#        format.html { redirect_to @door_log, :notice => 'Door log was successfully updated.' }
#        format.json { head :no_content }
#      else
#        format.html { render :action => "edit" }
#        format.json { render :json => @door_log.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

  # DELETE /door_logs/1
  # DELETE /door_logs/1.json
#  def destroy
#    @door_log = DoorLog.find(params[:id])
#    @door_log.destroy
#
#    respond_to do |format|
#      format.html { redirect_to door_logs_url }
#      format.json { head :no_content }
#    end
#  end
end
