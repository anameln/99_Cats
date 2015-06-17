class AddRequestorToCatRequests < ActiveRecord::Migration
  def change
    add_column :cat_rental_requests, :requester_id, :integer, nil:false, index:true
  end
end
