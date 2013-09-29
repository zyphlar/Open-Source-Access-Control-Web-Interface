@@default_settings = {
  :welcome_title => "Welcome to the Hackerspace Members Site",
  :welcome_body => "<p>We are a member-driven community workshop where you can learn, make cool stuff, meet other cool people, and make your city a better place to live!</p><p>You don't have to be a member to come visit, but if you're interested in volunteering or being a member, feel free to sign up here! For more information, <a href=\"/more_info\">Click Here</a>.</p>",
  :more_info_page => "No info here yet, bug a member about filling this part out!",
  :member_resources_inset => "No info here yet, bug a member about filling this part out!"
}

if ActiveRecord::Base.connection.tables.include?('settings') and !defined?(::Rake)
  @@default_settings.each do |key, value|
    Setting.save_default(key, value)
  end
end
