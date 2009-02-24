class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.integer :from_id
      t.integer :to_id
      t.string :subject
      t.text :body
      t.boolean :is_read, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
