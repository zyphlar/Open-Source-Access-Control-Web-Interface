class AddCosignerToContracts < ActiveRecord::Migration
  def change
    add_column :contracts, :cosigner, :string
  end
end
