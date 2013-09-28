@@default_settings = {
  :welcome_title => "Welcome to the Hackerspace Members Site", #Welcome to the HeatSync Labs Members App.
  :welcome_body => "<p>We are a member-driven community workshop where you can learn, make cool stuff, meet other cool people, and make your city a better place to live!</p><p>You don't have to be a member to come visit, but if you're interested in volunteering or being a member, feel free to sign up here! For more information, <a href=\"/more_info\">Click Here</a>.</p>", # <p>You can sign up to become a member here!</p>
  :more_info_page => "No info here yet, bug a member about filling this part out!",
  :member_resources_inset => "No info here yet, bug a member about filling this part out!"
#   <ul>
#   <li><%= link_to "Wiki", "http://wiki.heatsynclabs.org" %></li>
#   <li><%= link_to "Discussion Group", "http://groups.google.com/group/heatsynclabs" %></li>
#   <li><%= link_to "IRC", "irc://irc.freenode.net#heatsynclabs" %></li>
#   <li><%= link_to "Live Webcams", "http://live.heatsynclabs.org/" %></li>
#   <li>Lab Phone: (480) 751-1929</li>
#   <li>
#     <style type="text/css">
#      form input {font-family: 'Lucida Console', Monaco, monospace; }
#     </style>
    
#     <b>Send a Message!</b>
#     <form method="post" action="http://tweet.zyphon.com/signage.php">
#       <em>Type here and your message will show up on the LED sign in the front window!</em><br/>
#       <em>(Please be nice!)</em><br/>
#       <input type="text" name="msg" id="msg" value="  Hello" size="9" /> (max 9 chars per line)<br/>
#       <input type="text" name="msg2" id="msg2" value="  World" size="9" /><br/>
#       <input type="submit" name="submitbutton" id="submitbutton" value="Go!" />
#     </form>
#   </li>
# </ul>
}

if ActiveRecord::Base.connection.tables.include?('settings') and !defined?(::Rake)
  @@default_settings.each do |key, value|
    Setting.save_default(key, value)
  end
end
