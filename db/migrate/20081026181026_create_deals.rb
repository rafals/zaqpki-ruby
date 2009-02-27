class CreateDeals < ActiveRecord::Migration
  def self.up
    create_table :deals do |t|
      t.integer :sponsor_id
      t.string :description
      t.float :cost
      t.integer :snitch_id
      t.boolean :is_enabled, :default => true
      t.integer :icon
      t.timestamps
    end
  end

  def self.down
    drop_table :deals
  end
end
