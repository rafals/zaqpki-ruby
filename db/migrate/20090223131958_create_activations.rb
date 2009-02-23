class CreateActivations < ActiveRecord::Migration
  def self.up
    create_table :activations do |t|
      t.email :string
      t.token :string

      t.timestamps
    end
  end

  def self.down
    drop_table :activations
  end
end
