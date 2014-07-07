class StatisticsController < ApplicationController
  before_filter :load_and_authorize_user

  def index
  end

  def door_log
    # Get own user's door data
    cards = @user.cards
    card_hash = {}
    cards.each{|c| card_hash[c.card_number.to_i(16)%32767] = c.card_number}
    card_num_Rs = cards.map{|c| c.card_number.to_i(16)%32767}
    @door_logs = DoorLog.where("data = ?", card_num_Rs).order("created_at ASC")
    @door_logs.map{|l| 
      l.data = card_hash[l.data.to_i].to_i(16)
      l.key = DoorLog.key_legend[l.key]
    }

    @door_log_graph = []
    @door_logs.where("key = 'G'").group_by{|l| l.created_at.beginning_of_day}.each{|l| @door_log_graph << [l.first.to_time.to_i*1000,l.last.size]}

    respond_to do |format|
      format.html 
      format.json { render :json => @door_logs }
    end
  end

  def mac_log
    macs = @user.macs.where(:hidden => false).map{|m| m.mac}
    @mac_logs = MacLog.where(:mac => macs)
    @mac_log_graph = {}
    macs.each do |mac|
      mac_log = MacLog.where(:mac => mac)
  
      mac_times = []
      last_active = nil
      mac_log.each do |entry|
        # Find an activate followed immediately by a deactivate
        if entry.action == "activate"
          last_active = entry
        else
          if last_active && entry.action == "deactivate"
            # Calculate the time difference between the two and append to this mac's total time
            mac_times << [entry.created_at, ((entry.created_at - last_active.created_at)/60/60)]
          else
            # No pair found; discard.
            last_active = nil
          end
        end
      end
      mac_log_graph = []
      mac_times.group_by{|m| m.first.beginning_of_day}.each{|m| mac_log_graph << [m.first.to_time.to_i*1000,m.last.map{|n| n.last}.sum.round(2)]}
      # Store each mac in the hash with its graph
      @mac_log_graph[mac] = mac_log_graph
    end
    #@mac_log_graph = mac_log_grouped.map{|g| [g.first.to_time.to_i*1000, g.last.size] }

    respond_to do |format|
      format.html
      format.json { render :json => @mac_logs }
    end
  end

  def load_and_authorize_user
    @user = current_user
    authorize! :read, @user
  end
end
