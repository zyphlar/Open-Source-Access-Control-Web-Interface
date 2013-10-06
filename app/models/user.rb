class User < ActiveRecord::Base
  include Gravtastic
  gravtastic :size => 120, :default => ""

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :admin, :instructor, :member, :emergency_name, :emergency_phone, :current_skills, :desired_skills, :waiver, :emergency_email, :phone, :payment_method, :orientation, :member_level, :certifications, :hidden, :marketing_source, :payee, :accountant, :exit_reason, :twitter_url, :facebook_url, :github_url, :website_url, :email_visible, :phone_visible #TODO: make admin/instructor/member/etc not accessible

  has_many :cards
  has_many :user_certifications
  has_many :certifications, :through => :user_certifications
  has_many :payments
  has_many :macs

  validates_format_of [:twitter_url, :facebook_url, :github_url, :website_url], :with => URI::regexp(%w(http https)), :allow_blank => true

  after_create :send_new_user_email

  def absorb_user(user_to_absorb)
    # copy all attributes except email, password, name, and anything that isn't blank on the destination
    user_to_absorb.attributes.each_pair {|k,v|
      unless (v.nil? || k == :id || k == :email || k == :password || k == :name || k == :password_confirmation || k == :hidden || k == 'hidden' || k == :encrypted_password || !self.attributes[k].blank? )
        Rails.logger.info "Updating "+k.to_s+" from "+self[k].to_s
        self[k] = v
        Rails.logger.info "Updated "+k.to_s+" to "+self[k].to_s
      end
    }

    self.save!

    user_to_absorb.cards.each {|card| 
      Rails.logger.info "CARD BEFORE: "+card.inspect
      card.user_id = self.id
      card.save!
      Rails.logger.info "CARD AFTER: "+card.inspect
    }
    user_to_absorb.user_certifications.each {|user_cert|
      Rails.logger.info "CERT BEFORE: "+user_cert.inspect
      user_cert.user_id = self.id
      user_cert.save!
      Rails.logger.info "CERT AFTER: "+user_cert.inspect
    }
    user_to_absorb.payments.each {|payment|
      Rails.logger.info "PAYMENT BEFORE: "+payment.inspect
      payment.user_id = self.id
      payment.amount = 0 if payment.amount.nil? # Bypass validation on amount
      payment.save!
      Rails.logger.info "PAYMENT AFTER: "+payment.inspect
    }

    user_to_absorb.destroy
  end

  def name_with_email_and_visibility
    if hidden then
      "#{name} (#{email}) HIDDEN"
    else
      "#{name} (#{email})"
    end
  end

  def name_with_payee_and_member_level
    if payee.blank? then
      "#{name} - #{member_level_string}"
    else 
      "#{payee} for #{name} - #{member_level_string}"
    end
  end

  def member_level_string
    case self.member_level.to_i
    when 0
      "None"
    when 1
      "Unable"
    when 10..24
      "Volunteer"
    when 25..49
      "Associate ($25)"
    when 50..99
      "Basic ($50)"
    when 100..999
      "Plus ($100)"
    end
  end

  def self.member_levels
    {25 => "Associate", 50 => "Basic", 75 => "Basic", 100 => "Plus"}
  end

  def payment_status
    results = payment_status_calculation
    return results[:paid]
  end

  def member_status
    results = member_status_calculation
    return results[:rank]
  end

  def member_status_symbol
    results = member_status_calculation
    return "<img src='/#{results[:icon]}#{results[:flair]}-coin.png' title='#{results[:message]}' class='member-status-symbol' />"
  end

  def last_payment_date
    self.payments.maximum(:date)
  end

  def delinquency
    if self.payments.count > 0
      paydate = self.payments.maximum(:date)
      (Date.today - paydate).to_i
    else
      (Date.today - self.created_at.to_date).to_i
    end
  end

  def send_email(from_user,subject,body)
    Rails.logger.info UserMailer.email(self,from_user,subject,body).deliver
  end

  private

  def send_new_user_email
    Rails.logger.info UserMailer.new_user_email(self).deliver
  end

  def member_status_calculation
    # Begin output buffer
    message = ""
    icon = ""
    flair = ""
    rank = 0

    # First status item is level
    case self.member_level.to_i
    when 0..9
      if self.payments.count > 0 then
        message = "Former Member (#{(DateTime.now - self.payments.maximum(:date)).to_i/30} months ago)"
        icon = :timeout
        rank = 1
      else
        message = "Not a Member"
        icon = :no
        rank = 0
      end
    when 10..24
      message = "Volunteer"
      icon = :heart
      rank = 101
    when 25..49
      message = member_level_string
      icon = :copper
      rank = 250
    when 50..99
      message = member_level_string
      icon = :silver
      rank = 500
    when 100..999
      message = member_level_string
      icon = :gold
      rank = 1000
    end

    payment_results = payment_status_calculation
    flair = payment_results[:flair]
    rank = rank/10 unless payment_results[:paid]
    message = payment_results[:message] unless payment_results[:message].blank?
    
    return {:message => message, :icon => icon, :flair => flair, :rank => rank}
  end

  def payment_status_calculation
    flair = ""
    message = ""
    paid = true

    # Second status item is payment status
    case self.member_level.to_i
    when 25..999
      # There are payments
      if self.payments.count > 0 then
        # They're on time
        if self.payments.maximum(:date) > (DateTime.now - 60.days) 
          flair = "-paid"
          paid = true
        else
          message = "Last Payment #{(DateTime.now - self.payments.maximum(:date)).to_i/30} months ago"
          paid = false
        end
      else
        message = "No Payments Recorded"
        paid = false
      end
    end
    return {:message => message, :paid => paid, :flair => flair}
  end

end
