class AddOwnerToCats < ActiveRecord::Migration
  def change
    add_column :cats, :owner_id, :integer, nil: false, index: true 
  end
end
