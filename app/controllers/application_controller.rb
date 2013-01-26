class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|  
    if !current_user.nil? && current_user.orientation.blank? then
      flash[:alert] = "Sorry, you probably need to complete New Member Orientation before having access to this page. <br/>Please check your email and schedule a New Member Orientation with a volunteer."
    else
      flash[:alert] = "Nothing to see here!"
    end
    redirect_to root_url
  end

  @payment_methods = [[nil],["PayPal"],["Dwolla"],["Bill Pay"],["Check"],["Cash"],["Other"]]
  @payment_instructions = {nil => nil, :paypal => "Set up a monthly recurring payment to hslfinances@gmail.com", :dwolla => "Set up a monthly recurring payment to hslfinances@gmail.com", :billpay =>  "Have your bank send a monthly check to HeatSync Labs Treasurer, 140 W Main St, Mesa AZ 85201", :check => "Mail to HeatSync Labs Treasurer, 140 W Main St, Mesa AZ 85201 OR put in the drop safe at the Lab with a deposit slip firmly attached each month.", :cash => "Put in the drop safe at the Lab with a deposit slip firmly attached each month.", :other => "Hmm... talk to a Treasurer!"}
end
