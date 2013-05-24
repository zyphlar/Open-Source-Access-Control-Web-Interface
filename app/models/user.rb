class User < ActiveRecord::Base
  include Gravtastic
  gravtastic :size => 120, :default => ""

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :admin, :instructor, :member, :emergency_name, :emergency_phone, :current_skills, :desired_skills, :waiver, :emergency_email, :phone, :payment_method, :orientation, :member_level, :certifications, :hidden, :marketing_source, :payee, :accountant #TODO: make admin/instructor/member/etc not accessible

  has_many :cards
  has_many :user_certifications
  has_many :certifications, :through => :user_certifications
  has_many :payments

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

  def member_status
    case self.member_level.to_i
    when 0
      if self.payments.count > 0 then
       2
      else
       -1
      end
    when 1
      1
    when 10..24
      10
    when 25..999
      if self.payments.count > 0 then
        if self.payments.last.date < (DateTime.now - 45.days)
          3
        else
          case self.member_level.to_i
          when 25..49
            25
          when 50..99
            50
          when 100..999
            100
          end
        end
      else
        return 0
      end
    end
  end

  def member_status_symbol
    case self.member_level.to_i
    when 0
      if self.payments.count > 0 then
      "<span class='hoverinfo' title='Former Member (#{(DateTime.now - self.payments.last.date).to_i} days ago)'>:(</span>"
      else
      "<!-- Not a member -->"
      end
    when 1
      "Unable"
    when 10..24
      "<span class='hoverinfo' title='Volunteer'>&#9684;</span>"
    when 25..999
      if self.payments.count > 0 then
        if self.payments.last.date < (DateTime.now - 45.days) 
          "<span class='hoverinfo' title='Recently Lapsed (#{(DateTime.now - self.payments.last.date).to_i} days ago)'>&#9676;</span>"
        else
          case self.member_level.to_i
          when 25..49
            "<span class='hoverinfo' title='#{member_level_string}'>&#9681;</span>"
          when 50..99
            "<span class='hoverinfo' title='#{member_level_string}'>&#9685;</span>"
          when 100..999
            "<span class='hoverinfo' title='#{member_level_string}'>&#9679;</span>"
          end
        end
      else
        "<span class='hoverinfo' title='No Payments'>?</span>"
      end
    end
  end

  private

  def send_new_user_email
    Rails.logger.info UserMailer.new_user_email(self).deliver
  end

end
