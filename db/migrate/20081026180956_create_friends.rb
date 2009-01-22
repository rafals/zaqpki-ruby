class CreateFriends < ActiveRecord::Migration
  def self.up
    create_table :friends do |t|
      t.integer :owner_id
      t.integer :account_id
      t.float :saldo, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :friends
  end
end
