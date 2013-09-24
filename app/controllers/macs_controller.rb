class MacsController < ApplicationController
rescue_from CanCan::AccessDenied do |exception|
  today = Date.today
  event = Date.new(2013,9,1)

  if today == event
    redirect_to main_app.root_url, :alert => "CryptoParty today; no MAC scanning. Sorry, NSA!"
  else
    redirect_to main_app.root_url, :alert => "Nothing to see here!"
  end
end
load_and_authorize_resource :mac, :except => :create
load_and_authorize_resource :user, :through => :mac, :except => [:index, :show, :scan, :import]

before_filter :arp_lookup, :only => :new

#require "active_record"
require "optparse"
#require "rubygems"

def index
  #@active_macs = Mac.where(:active => true, :hidden => false)
  #@active_macs += Mac.where(:active => true, :hidden => nil)
  
  # De-dupe users for the public
  if can? :update, Mac then
    @active_macs = Mac.where("macs.active = ? AND (macs.hidden IS NULL OR macs.hidden = ?)", true, false).includes(:user).order("users.name ASC")
  elsif user_signed_in? then
    @active_macs = Mac.where("macs.active = ? AND (macs.hidden IS NULL OR macs.hidden = ?)", true, false).includes(:user).order("users.name ASC").group("users.name")
  else
    @active_macs = Mac.select("mac, note, user_id").where("macs.active = ? AND (macs.hidden IS NULL OR macs.hidden = ?)", true, false).joins(:user).order("users.name ASC").group("users.name, mac, note, user_id")
  end

  @hidden_macs = Mac.where("macs.active = ? AND macs.hidden = ?", true, true).order("note ASC")

  @all_macs = Mac.find(:all, :order => "LOWER(mac)")

  respond_to do |format|
    format.html
    format.json {
      @filtered_macs = Mac.select("macs.mac, users.name, macs.note").where("macs.active = ? AND (macs.hidden IS NULL OR macs.hidden = ?)", true, false).joins(:user)
      render :json => @filtered_macs 
    }
  end
end

  # GET /macs/1
  # GET /macs/1.json
  def show
    @mac = Mac.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @macs }
    end
  end

  # GET /macs/new
  # GET /macs/new.json
  def new
    @mac = Mac.new
    if can? :manage, Mac then
      @users = User.accessible_by(current_ability).sort_by(&:name)
    else 
      @users = [current_user]
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @mac }
    end
  end

  # GET /macs/1/edit
  def edit
    @mac = Mac.find(params[:id])
    if can? :manage, Mac then
      @users = User.accessible_by(current_ability).sort_by(&:name)
    else 
      @users = [current_user]
    end
  end

  # POST /macs
  def create
    @mac = Mac.new(params[:mac])
    @existing_mac = Mac.find_by_mac(@mac.mac)
        if can? :manage, Mac then
          @users = User.accessible_by(current_ability).sort_by(&:name)
        else 
          @users = [current_user]
        end
 
      if @existing_mac.present?
        if @existing_mac.user_id.nil?
          redirect_to edit_mac_path(@existing_mac), :notice => 'This MAC already exists, edit it here:'
        else
@mac.errors.add(:user,"for this MAC is already set to #{@existing_mac.user.name} -- please contact them or an admin if this is incorrect.")
          render :action => "new"
        end
      else
 
        respond_to do |format|
          if @mac.save
            format.html { redirect_to macs_path, :notice => 'MAC was successfully created.' }
            format.json { render :json => @mac, :status => :created, :location => @mac }
          else
            format.html { render :action => "new" }
            format.json { render :json => @mac.errors, :status => :unprocessable_entity }
          end
        end
      end
  end

  # PUT /macs/1
  # PUT /macs/1.json
  def update
    #Log who updated this
    @mac = Mac.find(params[:id])
    @mac.assign_attributes(params[:mac])
    #@mac.user_id = params[:mac][:user_id]
    authorize! :update, @mac

    if can? :manage, Mac then
      @users = User.accessible_by(current_ability).sort_by(&:name)
    else 
      @users = [current_user]
    end

    respond_to do |format|
      if @mac.save
        format.html { redirect_to macs_path, :notice => 'MAC was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @mac.errors, :status => :unprocessable_entity }
      end
    end
  end

def arp_lookup
  @ip = request.env['REMOTE_ADDR']
  @arp = %x(/usr/sbin/arp -a | grep #{@ip})
end

def scan
Rails.logger.info "starting scan..."
	# Command line arguments
	options = {};
	OptionParser.new { |opts|
		opts.banner = "Usage: pamela-scanner.rb --interface=en0"

		options[:verbose] = true
		opts.on("v", "--verbose", "Run verbosely") { |verbose|
			options[:verbose] = verbose
		}

		options[:interface] = "eth0"
		opts.on("i", "--interface=interface", "Network Interface") { |interface|
			options[:interface] = interface
		}

		options[:max_age] = 20
		opts.on("a", "--max-age=minutes", "Minutes to keep expired macs active") { |max_age|
			options[:max_age] = max_age.to_i
		}

		options[:db_host] = "configure_me"
		opts.on("r", "--db-host=host", "Database Host") { |host|
			options[:db_host] = host
		}

		options[:db_name] = "configure_me"
		opts.on("n", "--db-name=name", "Database Name") { |name|
			options[:db_name] = name
		}

		options[:db_user] = "configure_me"
		opts.on("u", "--db-user=user", "Database User") { |user|
			options[:db_user] = user
		}

		options[:db_password] = "configure_me"
		opts.on("p", "--db-password=password", "Database Password") { |password|
			options[:db_password] = password
		}

	}.parse!

	# Open the database
	#ActiveRecord::Base::establish_connection(
	#	:adapter  => "mysql2",
	#	:host     => options[:db_host],
	#	:database => options[:db_name],
	#	:username => options[:db_user],
	#	:password => options[:db_password])

	#class Mac < ActiveRecord::Base
	#end

	#class MacLog < ActiveRecord::Base
	#end

	# Scan the network for mac addresses
	macs = {};
	command = sprintf("arp-scan -R --interface=%s --localnet", options[:interface])
	if options[:verbose]
		Rails.logger.info "Running [#{command}]"
	end
	IO.popen(command) { |stdin|
		Rails.logger.info "Reading stdin: "+stdin.inspect
		stdin.each { |line| 
			next if line !~ /^([\d\.]+)\s+([[:xdigit:]:]+)\s/;
			macs[$2] = $1;
		}
	}

	# Scan the existing macs and update each record as necessary
	Mac.find(:all).each { |entry|
		mac = entry.mac.downcase
		ip = entry.ip
		if macs.has_key?(mac)
			if ! entry.active || ! entry.since
				Rails.logger.info "Activating #{mac} at #{ip}" if options[:verbose]
				entry.since = Time.now
				MacLog.new(:mac => mac, :ip => ip, :action => "activate").save
			end
			entry.active = 1
			entry.ip = ip
			entry.refreshed = Time.now
			entry.save
			macs.delete(mac)
			next
		end

		# Entry is no longer current
		if entry.active
			ageMinutes = ((Time.now - entry.refreshed)/60).to_i
			next if ageMinutes < options[:max_age]
			Rails.logger.info "Deactivating #{mac}, #{ageMinutes} minutes old" if options[:verbose]
			entry.active = 0
			entry.save
			MacLog.new(:mac => mac, :ip => ip, :action => "deactivate").save
		end
	}

	# Add entries for any macs not already in the db
	macs.each { |mac, ip|
		Rails.logger.info "Activating new entry #{mac} at #{ip}" if options[:verbose]
		Mac.new(:mac => mac, :ip => ip, :active => 1, :since => Time.now, :refreshed => Time.now).save
		Rails.logger.info MacLog.new(:mac => mac, :ip => ip, :action => "activate").save
	}

@log = MacLog.all

end #def scan


def import

require 'csv'    

csv_text = File.read('mac_log.csv')
csv = CSV.parse(csv_text)

@output = []

csv.each do |row|
  @output += [row[1], Mac.create({:mac => row[0], :note => row[1], :hidden => row[2]}) ]
end

end

end
