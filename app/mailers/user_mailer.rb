class UserMailer < ActionMailer::Base
  default :from => "wiki@heatsynclabs.org"

  def new_user_email(user)
    @user = user
    @url  = "http://members.heatsynclabs.org"

    @admins = User.where(:name => "Will Bradley")
    @admins.each do |admin|
      mail(:to => admin.email, :subject => "New HeatSync Member")
    end
  end
end
