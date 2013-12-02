class AddSocialMediaToUsers < ActiveRecord::Migration
  def change
    add_column :users, :twitter_url, :string
    add_column :users, :facebook_url, :string
    add_column :users, :github_url, :string
    add_column :users, :website_url, :string
    add_column :users, :email_visible, :boolean
    add_column :users, :phone_visible, :boolean
  end
end
