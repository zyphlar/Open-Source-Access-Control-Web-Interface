class MoveCardDataToCards < ActiveRecord::Migration
  def up
    User.all.each do |u|
      u.cards.create(:id => u.card_id, :name => u.name, :card_number => u.card_number, :card_permissions => u.card_permissions)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
