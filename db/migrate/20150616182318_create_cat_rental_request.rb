class CreateCatRentalRequest < ActiveRecord::Migration
  def change
    create_table :cat_rental_requests do |t|
      t.integer :cat_id, null: false, index: true
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.string :status, default: "PENDING"

      t.timestamps
    end
  end
end
