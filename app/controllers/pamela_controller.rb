class PamelaController < ApplicationController

#require "active_record"
require "optparse"
#require "rubygems"

def index
  @macs = Mac.all
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
    @users = User.all.sort_by(&:name)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @mac }
    end
  end

  # GET /macs/1/edit
  def edit
    @mac = Mac.find(params[:id])
    @users = User.all.sort_by(&:name)
  end

  # POST /macs
  # POST /user
  def create
    @mac = Mac.new(params[:mac])

    respond_to do |format|
      if @mac.save
        format.html { redirect_to "/pamela", :notice => 'Mac was successfully created.' }
        format.json { render :json => @mac, :status => :created, :location => @mac }
      else
        format.html { render :action => "new" }
        format.json { render :json => @mac.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /macs/1
  # PUT /macs/1.json
  def update
    #Log who updated this
    @mac = Mac.find(params[:id])

    respond_to do |format|
      if @mac.update_attributes(params[:mac])
        format.html { redirect_to "/pamela", :notice => 'User certification was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @mac.errors, :status => :unprocessable_entity }
      end
    end
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
		Rails.logger.info "Existing MAC: "+entry.inspect
		mac = entry.mac
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
		MacLog.new(:mac => mac, :ip => ip, :action => "activate").save
	}

@log = MacLog.all

end #def scan


end
