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
  def download
    @results = DoorLog.download_from_door

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @results }
    end
  end

end
