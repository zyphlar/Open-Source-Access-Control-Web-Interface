class UserMailer < ActionMailer::Base
  default :from => "no-reply@heatsynclabs.org"

  def new_user_email(user)
    @user = user
    @url  = "http://members.heatsynclabs.org"

    mail(:to => 'member-notifications@heatsynclabs.org', 
    	:subject => "New HSL Member: "+user.name)
  end

  def email(to_user,from_user,subject,body)
    @url  = "http://members.heatsynclabs.org"
    @body = body
    @from_user = from_user

    mail(:to => to_user.email,
    	:subject => "HSL Message: "+subject)
  end
end
