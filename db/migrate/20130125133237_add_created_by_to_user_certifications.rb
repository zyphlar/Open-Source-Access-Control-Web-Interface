class AddCreatedByToUserCertifications < ActiveRecord::Migration
  def change
    add_column :user_certifications, :created_by, :integer
  end
end
