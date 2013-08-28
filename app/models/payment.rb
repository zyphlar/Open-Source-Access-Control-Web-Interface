class Payment < ActiveRecord::Base
  belongs_to :user
  has_one :ipn
  has_one :paypal_csv
  attr_accessible :date, :user_id, :created_by, :amount

  validates_presence_of :user_id, :date, :amount # not created_by
  validates_uniqueness_of :date, :scope => :user_id, :message => ' of payment already exists for this user.' 


  def human_date
    if date.year < DateTime.now.year
      date.strftime("%b %e, %y")
    else
      date.strftime("%b %e")
    end
  end
end
