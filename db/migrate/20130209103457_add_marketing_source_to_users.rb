class AddMarketingSourceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :marketing_source, :string
  end
end
