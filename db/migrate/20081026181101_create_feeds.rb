class CreateFeeds < ActiveRecord::Migration
  def self.up
    create_table :feeds do |t|
      t.integer :account_id
      t.integer :deal_id
      t.integer :disabler_id
      t.integer :friend_id
      t.integer :comment_id
      t.boolean :is_enabled, :default => true
      t.boolean :is_sponsored
      t.boolean :is_sponged
      t.boolean :is_snitched
      t.string :type
      t.timestamps
    end
  end

  def self.down
    drop_table :feeds
  end
end
