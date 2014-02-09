class AddActiveToUsers < ActiveRecord::Migration
  def change
    add_column :users, :active, :boolean
    add_column :users, :waiver, :datetime
    add_column :users, :orientation, :datetime
    add_column :users, :emergency_name, :string
    add_column :users, :emergency_phone, :string
    add_column :users, :emergency_email, :string
    add_column :users, :member_level, :string
    add_column :users, :payment_method, :string
    add_column :users, :phone, :string
    add_column :users, :current_skills, :string
    add_column :users, :desired_skills, :string
  end
end
