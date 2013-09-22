class ChangeSurveysToText < ActiveRecord::Migration
  def up
    change_column :users, :current_skills, :text, :limit => nil
    change_column :users, :desired_skills, :text, :limit => nil
    change_column :users, :marketing_source, :text, :limit => nil
  end

  def down
    change_column :users, :current_skills, :string
    change_column :users, :desired_skills, :string
    change_column :users, :marketing_source, :string
  end
end
