class SpaceApiController < ApplicationController
  authorize_resource :except => :index
  before_filter :authenticate_user!, :except => :index

  def index
    @json = JSON.parse(Setting.space_api_json_template)
    door_status = DoorLog.show_status # Expect {:unlocked => boolean, :door_1_locked => boolean, :door_2_locked => boolean}

    @json["open"] = door_status[:unlocked]
    
    if( door_status[:unlocked] )
      @json["status"] = "doors_open=both"
    elsif( !door_status[:door_1_locked] )
      @json["status"] = "doors_open=door1"
    elsif( !door_status[:door_2_locked] )
      @json["status"] = "doors_open=door2"
    else
      @json["status"] = "doors_open=none"
    end

    respond_to do |format|
      format.html
      format.json { 
        response.headers['Access-Control-Allow-Origin'] = '*'
        response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
        render :json => @json
      }
    end
  end

end
