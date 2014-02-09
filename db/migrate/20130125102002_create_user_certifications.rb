class CreateUserCertifications < ActiveRecord::Migration
  def change
    create_table :user_certifications do |t|
      t.integer :user_id
      t.integer :certification_id

      t.timestamps
    end
  end
end
