class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :user_name, presence: true, unique: true
      t.string :session_token, presence: true, unique: true
      t.string :password_digest, presence: true
      t.timestamps
    end
  end
end
