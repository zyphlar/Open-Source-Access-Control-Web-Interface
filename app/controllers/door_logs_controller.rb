class DoorLogsController < ApplicationController
  authorize_resource :except => :auto_download
  before_filter :authenticate_user!, :except => :auto_download

  # GET /door_logs
  # GET /door_logs.json
  def index
#    @door_logs = DoorLog.find(:all, :order => "created_at DESC", :limit => 1000)
    @door_logs = DoorLog.where("key NOT LIKE 'alarm%' AND key != 'armed' AND key != 'activated'").order("created_at DESC").limit(3000)


    begin
      @start_date = DateTime.parse(params[:start])
      @end_date = DateTime.parse(params[:end])
    rescue
      @start_date = DateTime.now - 2.weeks
      @end_date = DateTime.now
    end

    @door_logs_by_hour = DoorLog.where("created_at > ? AND created_at < ? AND (key = ? OR key = ?)", @start_date, @end_date,"door_1_locked","door_2_locked").order("created_at ASC").group_by(&:key)
    @door_log_graph = [
      @door_logs_by_hour["door_1_locked"].map{|d| [d.created_at.to_time.to_i*1000, 1^d.data.to_i]}, # use XOR to invert 1 into 0 and vice versa
      @door_logs_by_hour["door_2_locked"].map{|d| [d.created_at.to_time.to_i*1000, 1^d.data.to_i]}
    ]

    #  @door_logs_by_hour.each do |door_log|
    #    # Add one computer for activate, subtract one for deactivate
    #    if door_log.data == 1
    #      
    #    elsif door_log.data == 0
    #      mac_running_balance -= 1
    #    end

    #    @door_log_graph << [time.to_time.to_i*1000,mac_running_balance]
    #  end



    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @door_logs }
    end
  end

  # GET /door_logs/download
  def download
    @results = DoorLog.download_from_door

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @results }
    end
  end

  # GET /door_logs/auto_download
  def auto_download
    @results = DoorLog.download_from_door
    @status = DoorLog.download_status # for space_api

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @results }
    end
  end


end
