class HomeController < ApplicationController

def index
  @num_certs = UserCertification.count
  @recent_certs = UserCertification.where("created_at > ?", DateTime.now - 7.days).count
  @num_users = User.count
  @recent_users = User.where("created_at > ?", DateTime.now - 7.days).count
  @num_door_opens = DoorLog.where("key = 'G'").count
  @recent_door_opens = DoorLog.where("key = 'G' AND created_at > ?", DateTime.now - 7.days).count
  @num_door_denieds = DoorLog.where("key = 'D'").count
  @recent_door_denieds = DoorLog.where("key = 'D' AND created_at > ?", DateTime.now - 7.days).count

    respond_to do |format|
      format.html # index.html.erb
    end
end

end
