class CreateContracts < ActiveRecord::Migration
  def change
    create_table :contracts do |t|
      t.integer  :user_id
      t.string  :first_name
      t.string  :last_name
      t.datetime :signed_at
      t.string   :document_file_name
      t.string   :document_content_type
      t.integer  :document_file_size
      t.datetime :document_updated_at

      t.timestamps
    end
  end
end
