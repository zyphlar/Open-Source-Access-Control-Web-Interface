class DoorMailer < ActionMailer::Base
  default :from => "no-reply@heatsynclabs.org"

  def alert(status)
    @url  = "http://members.heatsynclabs.org"
    @status = status

    mail(:to => 'will@heatsynclabs.org', 
    	:subject => "HSL Doors")
  end

end
