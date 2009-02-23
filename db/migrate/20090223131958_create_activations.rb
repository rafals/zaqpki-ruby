class CreateActivations < ActiveRecord::Migration
  def self.up
    create_table :activations do |t|
      t.string :email
      t.string :token

      t.timestamps
    end
  end

  def self.down
    drop_table :activations
  end
end
