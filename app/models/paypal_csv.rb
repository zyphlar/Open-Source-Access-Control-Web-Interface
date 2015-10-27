require 'csv'
class PaypalCsv < ActiveRecord::Base
  attr_accessible :data, :_address_status, :_counterparty_status, :_currency, :_fee, :_from_email_address, :_gross, :_item_id, :_item_title, :_name, :_net, :_status, :_time, :_time_zone, :_to_email_address, :_transaction_id, :_type, :date, :string
  belongs_to :payment

  after_create :create_payment

  def date_parsed
    begin
      Date.strptime(self._date, "%m/%d/%Y")
    rescue
      Date.new
    end
  end

  def self.batch_import_from_csv(filename)
    csv = CSV.table(filename)
    csv.each do |row| 
      paypal_csv = PaypalCsv.new()
logger.fatal row.inspect
      paypal_csv.attributes.each do |c|
        # Try finding the column without a prepended _ first (compatibility with new CSV format)
        unless row[c.first[1..-1].to_sym].nil?
          paypal_csv[c.first.to_sym] = row[c.first[1..-1].to_sym]
        end
        # If there's an exact match, it takes precedence
        unless row[c.first.to_sym].nil?
          paypal_csv[c.first.to_sym] = row[c.first.to_sym]
        end
      end

      paypal_csv.data = row.to_json
      paypal_csv.save
    end
    
    return true
  end

  def link_payment
    create_payment
  end

  private
  def create_payment
logger.fatal self.inspect

    # find user by email, then by payee
    user = User.where("lower(email) = ?", self._from_email_address.downcase).first
    user = User.where("lower(payee) = ?", self._from_email_address.downcase).first if user.nil? && self._from_email_address.present?

    # Only create payments if the CSV matches a member
    if user.present?
      # And is a payment (not a cancellation, etc)
      payment_types = ["Subscription Payment Processed","Recurring Payment Received","Payment Received"]
      if payment_types.include?(self._type)
        # And a member level
        if User.member_levels[self._gross.to_i].present?
          payment = Payment.new
          payment.date = Date.strptime(self._date, "%m/%d/%Y") #7/6/2013 for Jul 06
          payment.user_id = user.id
          payment.amount = self._gross
          if payment.save
            self.payment_id = payment.id
            self.save!
          else
            return [false, "Unable to link payment. Payment error: #{payment.errors.full_messages.first}"]
          end
        else
          return [false, "Unable to link payment. Couldn't find membership level '#{self._gross.to_i}'."]
        end
      else
        return [false, "Unable to link payment. Transaction is a '#{self._type}' instead of '#{payment_types.inspect}'."]
      end
    else
      return [false, "Unable to link payment. Couldn't find user/payee '#{self._from_email_address}'."]
    end

    return [true]
  end
end
