class SpaceApiController < ApplicationController
  # Individually remove authorizing stuff since there is no SpaceApi model
  authorize_resource :except => [:index, :simple, :access, :access_post, :alert_if_not_status]
  # User auth here happens via params, instead of form.
  before_filter :authenticate_user!, :except => [:index, :simple, :access, :access_post, :alert_if_not_status]

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
        response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
        render :json => @json
      }
    end
  end

  def simple
    door_status = DoorLog.show_status # Expect {:unlocked => boolean, :door_1_locked => boolean, :door_2_locked => boolean}
    render :json => door_status
  end

  def access
    @status = DoorLog.show_status

    # Nothing, just render form
    unless user_signed_in?
      @output =  "Invalid email or password. Please login with your Members DB email and password below."
    else
      unless can? :access_doors_remotely, :door_access
        @output =  "Sorry, your account isn't able to control doors remotely."
      else
        @output = "Ready to control doors. Send POST params to this URL as per the HTML form."
      end
    end

    # Render the form again (or result)
    respond_to do |format|
      format.html
      format.json {
        response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
        render :json => @output
      }
    end
  end

  def access_post
    @output = ""

    #if params['cmd'] == "check-login" then
    #  if users[params['user']] && users[params['user']]['pass'].to_s == (Digest::SHA2.new(bitlen=512) << params['pass']).to_s then
    #    @output +=  '{ "login": "okay" }'
    #  else
    #    @output +=  '{ "login": "fail" }'
    #  end
    # 
    #  exit
    #end
    
    # Stop unless signed in already, OR if the supplied user/pass params are good.
    unless current_user || check_auth(params['user'],params['pass'])
      @output +=  "Invalid email or password."
    else
      # Stop unless the user can access the door system
      unless can? :access_doors_remotely, :door_access
        @output += "Sorry, your account isn't able to control doors remotely. Ask an admin if this is incorrect."
        Rails.logger.warn "----------\r\nWARNING: DOOR ACCESS ATTEMPT DENIED. USER #{current_user.inspect}\r\n----------"
      else
        # Stop unless we've got a command to run
        unless params['cmd']
          @output += "No command specified."
        else 
          # Log the access
          Rails.logger.info "Door access: user #{current_user.inspect}"
          DoorLog.create!({:key => "rem_"+DoorLog.parse_command(params['cmd'])[:url_param], :data => current_user.id})

          # Execute the access
          ## unless it's unlocking the back door, per HYH 20180222 - Nate P
          unless params['cmd'] == "unlock-rear"
            @output += DoorLog.execute_command(params['cmd'])
          else
            @output += "Attempted to unlock the back door. This is no longer allowed."
            Rails.logger.warn "----------\r\nWARNING: ATTEMPTED TO UNLOCK REAR DOOR. USER #{current_user.inspect}\r\n----------"
          end
        end 
      end
    end

    # Render the form again (or result)
    respond_to do |format|
      format.html {
        render :access
      }
      format.json {
        response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
        render :json => @output
      }
    end

  end

  # Expect status to be "open" or "closed"
  def alert_if_not_status
    @expected_status = params['status']
    @status = DoorLog.show_status

    if !["open","closed"].include?(@expected_status)
      @output = "USAGE: Specify an expected status (/alert_if_not/open or /alert_if_not/closed). Alert emails will be sent if status doesn't match."
    elsif @expected_status.to_s == "open" && @status[:unlocked] == true
      @output = "Unlocked Status is OK."
    elsif @expected_status.to_s == "closed" && @status[:unlocked] == false
      @output = "Unlocked Status is OK."
    else
      @output = "Unlocked Status is NOT OK. Alerting."
      @output += " - Mail result: "
      @output += DoorMailer.alert(@status).deliver.inspect
    end

    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    render :json => {response: @output, status: @status}
  end

end
