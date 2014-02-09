class AddUpdatedByToUserCertifications < ActiveRecord::Migration
  def change
    add_column :user_certifications, :updated_by, :integer
  end
end
