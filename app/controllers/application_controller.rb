class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|  
    if current_user.orientation.blank? then
      flash[:alert] = "Sorry, you need to complete New Member Orientation before having access to this page. <br/>Please check your email and schedule a New Member Orientation with a volunteer."
      redirect_to root_url
    end
  end
end
