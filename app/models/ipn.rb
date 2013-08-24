class Ipn < ActiveRecord::Base
  attr_accessible :data
  belongs_to :payment

  after_create :create_payment

  def self.new_from_dynamic_params(params)
    ipn = Ipn.new()

    ipn.attributes.each do |c|
      unless params[c.first.to_sym].nil?
        ipn[c.first.to_sym] = params[c.first.to_sym]
      end
    end

    return ipn
  end

  def link_payment
    create_payment
  end

  private
  def create_payment
    # find user by email, then by payee
    user = User.find_by_email(self.payer_email)
    user = User.find_by_payee(self.payer_email) if user.nil? && self.payer_email.present?

    # Only create payments if the amount matches a member level
    if user.present?
      if User.member_levels[self.payment_gross.to_i].present?
        payment = Payment.new
        payment.date = self.payment_date
        payment.user_id = user.id
        payment.amount = self.payment_gross
        if payment.save
          self.payment_id = payment.id
          self.save!
        else
          return [false, "Unable to link payment. Payment error: #{payment.errors.full_messages.first}"]
        end
      else
        return [false, "Unable to link payment. Couldn't find membership level '#{self.payment_gross.to_i}'."]
      end
    else
      return [false, "Unable to link payment. Couldn't find user/payee '#{self.payer_email}'."]
    end
  end

end
