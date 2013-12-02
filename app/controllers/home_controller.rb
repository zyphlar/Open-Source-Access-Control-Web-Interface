class HomeController < ApplicationController

def index
  @num_certs = UserCertification.count
  @recent_certs = UserCertification.where("created_at > ?", DateTime.now - 7.days).count
  @num_users = User.count
  @recent_users = User.where("created_at > ?", DateTime.now - 7.days).count
  # Payments: member levels are multipled by 10 to indicate current payment; 25 x 10 = 250
  @num_paid_users = User.all.select{|u| u.member_status >= 250 }.count
  @num_plus_users = User.all.select{|u| u.member_status == 1000 }.count
  @num_basic_users = User.all.select{|u| u.member_status == 500 }.count
  @num_associate_users = User.all.select{|u| u.member_status == 250 }.count
  @num_delinquent_users = User.all.select{|u| !u.payment_status }.count
  if can? :read, User then
    @recent_user_names = User.where("member_level > 10").accessible_by(current_ability).order('created_at desc').limit(5)
  end
  @num_door_opens = DoorLog.where("key = 'G'").count
  @today_door_opens = DoorLog.where("key = 'G' AND created_at > ?", DateTime.now - 1.day).count
  @recent_door_opens = DoorLog.where("key = 'G' AND created_at > ?", DateTime.now - 7.days).count
  @num_door_denieds = DoorLog.where("key = 'D'").count
  @recent_door_denieds = DoorLog.where("key = 'D' AND created_at > ?", DateTime.now - 1.month).count
  @num_logins = User.sum('sign_in_count')
  @recent_logins = User.where('current_sign_in_at > ?',Date.today - 7.days).count
  @num_macs = Mac.count
  @recent_macs = Mac.where("since > ?", DateTime.now - 1.day).count

    respond_to do |format|
      format.html # index.html.erb
    end
end

def more_info
  respond_to do |format|
    format.html # more_info.html.erb
  end
end

end
