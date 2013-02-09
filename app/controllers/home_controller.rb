class HomeController < ApplicationController

def index
  @num_certs = UserCertification.count
  @recent_certs = UserCertification.where("created_at > ?", DateTime.now - 7.days).count
  @num_users = User.count
  @recent_users = User.where("created_at > ?", DateTime.now - 7.days).count
  if can? :read, User then
    @recent_user_names = User.where("created_at > ?", DateTime.now - 7.days)
  end
  @num_door_opens = DoorLog.where("key = 'G'").count
  @today_door_opens = DoorLog.where("key = 'G' AND created_at > ?", DateTime.now - 1.day).count
  @recent_door_opens = DoorLog.where("key = 'G' AND created_at > ?", DateTime.now - 7.days).count
  @num_door_denieds = DoorLog.where("key = 'f'").count
  @recent_door_denieds = DoorLog.where("key = 'f' AND created_at > ?", DateTime.now - 7.days).count
  @num_macs = Mac.count
  @recent_macs = Mac.where("since > ?", DateTime.now - 1.day).count

    respond_to do |format|
      format.html # index.html.erb
    end
end

end
