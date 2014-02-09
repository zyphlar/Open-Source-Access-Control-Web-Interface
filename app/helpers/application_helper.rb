module ApplicationHelper
  @payment_methods = [[nil],["PayPal"],["Dwolla"],["Bill Pay"],["Check"],["Cash"],["Other"]]
  @payment_instructions = {nil => nil, :paypal => "Set up a monthly recurring payment to hslfinances@gmail.com", :dwolla => "Set up a monthly recurring payment to hslfinances@gmail.com", :billpay =>  "Have your bank send a monthly check to HeatSync Labs Treasurer, 140 W Main St, Mesa AZ 85201", :check => "Mail to HeatSync Labs Treasurer, 140 W Main St, Mesa AZ 85201 OR put in the drop safe at the Lab with a deposit slip firmly attached each month.", :cash => "Put in the drop safe at the Lab with a deposit slip firmly attached each month.", :other => "Hmm... talk to a Treasurer!"}

  def sort_link(title, column, options = {})
    condition = options[:unless] if options.has_key?(:unless)
    sort_dir = params[:dir] == 'up' ? 'down' : 'up'
    link_to_unless condition, title, request.parameters.merge( {:sort => column, :dir => sort_dir} )
  end
end
