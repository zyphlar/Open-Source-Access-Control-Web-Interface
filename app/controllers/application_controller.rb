class ApplicationController < ActionController::Base
  protect_from_forgery

  force_ssl if: :ssl_configured?

  def ssl_configured?
    !Rails.env.development? && !Rails.env.test?
  end

  rescue_from CanCan::AccessDenied do |exception|  
    if !current_user.nil? && current_user.orientation.blank? then
      flash[:alert] = "Sorry, you probably need to complete New Member Orientation before having access to this page. <br/>Please check your email and schedule a New Member Orientation with a volunteer."
    else
      flash[:alert] = "Nothing to see here!"
    end
    Rails.logger.warn "----------\r\nWARNING: AccessDenied Exception: #{exception.inspect} User: #{current_user.inspect}\r\n----------"
    redirect_to root_url
  end

  @payment_methods = [[nil],["PayPal"],["Dwolla"],["Bill Pay"],["Check"],["Cash"],["Other"]]
  @payment_instructions = {nil => nil, :paypal => "Set up a monthly recurring payment to hslfinances@gmail.com", :dwolla => "Set up a monthly recurring payment to hslfinances@gmail.com", :billpay =>  "Have your bank send a monthly check to HeatSync Labs Treasurer, 140 W Main St, Mesa AZ 85201", :check => "Mail to HeatSync Labs Treasurer, 140 W Main St, Mesa AZ 85201 OR put in the drop safe at the Lab with a deposit slip firmly attached each month.", :cash => "Put in the drop safe at the Lab with a deposit slip firmly attached each month.", :other => "Hmm... talk to a Treasurer!"}

  # Check authorization of a user / sign them in manually
  def check_auth(email,password)
    resource = User.find_by_email(email)
    if resource && resource.valid_password?(password)
      resource.remember_me = true
      sign_in :user, resource
      return true
    else
      return false
    end
  end


end

# Add a "fit" function to sanitize inputs for mac history
class Fixnum
  def fit(range)
    self > range.max ? range.max : (self < range.min ? range.min : self)
  end
end

