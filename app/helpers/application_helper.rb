module ApplicationHelper
  @payment_methods = [[nil],["PayPal"],["Dwolla"],["Bill Pay"],["Check"],["Cash"],["Other"]]
  @payment_instructions = {nil => nil, :paypal => "Set up a monthly recurring payment to hslfinances@gmail.com", :dwolla => "Set up a monthly recurring payment to hslfinances@gmail.com", :billpay =>  "Have your bank send a monthly check to HeatSync Labs Treasurer, 140 W Main St, Mesa AZ 85201", :check => "Mail to HeatSync Labs Treasurer, 140 W Main St, Mesa AZ 85201 OR put in the drop safe at the Lab with a deposit slip firmly attached each month.", :cash => "Put in the drop safe at the Lab with a deposit slip firmly attached each month.", :other => "Hmm... talk to a Treasurer!"}

  def sort_link(title, column, options = {})
    condition = options[:unless] if options.has_key?(:unless)
    sort_dir = params[:dir] == 'up' ? 'down' : 'up'
    link_to_unless condition, title, request.parameters.merge( {:sort => column, :dir => sort_dir} )
  end

  def li_link_to(name = nil, options = nil, html_options = nil, &block)
    html_options, options, name = options, name, block if block_given?
    options ||= {}
  
    html_options = convert_options_to_data_attributes(options, html_options)
  
    url = url_for(options)
    html_options['href'] ||= url
  
    if current_page?(url)
      content_tag(:li, class: "active") do
        content_tag(:a, name || url, html_options, &block)
      end
    else
      content_tag(:li) do
        content_tag(:a, name || url, html_options, &block)
      end
    end
  end

end
