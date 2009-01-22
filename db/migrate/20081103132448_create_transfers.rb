class CreateTransfers < ActiveRecord::Migration
  def self.up
    create_table :transfers do |t|
      t.integer :sponger_id
      t.integer :sponsor_id
      t.integer :deal_id
      t.float :cost

      t.timestamps
    end
    j = Account.create :name => 'jedzej', :email => 'jedzej@gmail.com'
    r = Account.create :name => 'rav', :email => 'ravsobota@gmail.com'
    k = Account.create :name => 'kraxi', :email => 'm.krakowiak@gmail.com'
    m = Account.create :name => 'martyna', :email => 'mantalynka@gmail.com'
    u = Account.create :name => 'jercik', :email => 'jercik@gmail.com'
    
    r.connect j
    r.connect m
    r.connect k
    r.connect u
    
  end

  def self.down
    drop_table :transfers
  end
end
