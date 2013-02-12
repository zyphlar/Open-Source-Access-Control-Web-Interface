class Payment < ActiveRecord::Base
  belongs_to :user
  attr_accessible :date, :user_id, :created_by

  validates_presence_of :user_id, :date, :created_by
  validates_uniqueness_of :date, :scope => :user_id, :message => ' of payment already exists for this user.' 

  def human_date
    if date.year < DateTime.now.year
      date.strftime("%b %e, %y")
    else
      date.strftime("%b %e")
    end
  end
end
