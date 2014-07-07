class ResourceCategory < ActiveRecord::Base
  has_many :resources
  attr_accessible :name

  before_destroy :has_resources?

  private

  def has_resources?
    errors.add(:base, "Cannot delete category with associated resources") unless resources.count == 0
    errors.blank? #return false, to not destroy the element, otherwise, it will delete.
  end
end
