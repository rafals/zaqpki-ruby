class Deal < ActiveRecord::Base
  belongs_to :sponsor, :class_name => 'Account', :foreign_key => 'sponsor_id'
  has_and_belongs_to_many :spongers, :class_name => 'Account'
  has_many :feeds
  # has_many :existing_observers, :through => :feeds, :source => :account
  belongs_to :snitch, :class_name => 'Account'
  has_many :transfers, :dependent => :destroy
  has_many :comments
  
  after_create :create_feeds, :create_transfers
  after_update :update_transfers
  
  def connect_transactors
    spongers.each do |sponger|
      sponger.connect sponsor
    end
  end
  
  def observers
    observers_ids = {}
    observers_ids[sponsor.id] = true
    yield sponsor
    spongers.each do |sponger|
      unless observers_ids[sponger.id]
        observers_ids[sponger.id] = true
        yield sponger
      end
      sponger.mutual_friends sponsor do |mutual|
        unless observers_ids[mutual.id]
          observers_ids[mutual.id] = true
          yield mutual
        end
      end
    end
  end
  
  def create_feeds
    observers do |observer|
      feed = DealFeed.new :account => observer, :deal => self
      feed.is_sponsored = true if observer == sponsor
      feed.is_sponged = true if spongers.include? observer
      feed.is_snitched = true if observer == snitch
      feed.save
    end
  end
  
  def destroy_transfers
    transfers.each { |t| t.destroy }
  end
  
  def update_transfers
    destroy_transfers
    create_transfers
  end

  def create_transfers
    personal_cost = cost.to_f / spongers.length.to_f
    spongers.each do |sponger| 
      unless sponger == sponsor
        t = Transfer.new
        t.deal_id = id
        t.sponsor = sponsor
        t.sponger = sponger
        t.cost = personal_cost
        t.save
      end
    end
  end
  
  def disable_by disabler
    if self.is_enabled == true
      destroy_transfers
      feeds.each do |feed|
        feed.is_enabled = false
        feed.save
        DisablingFeed.create :account => feed.account, :deal => self, :disabler => disabler
      end
      self.is_enabled = false
      self.save
    end
  end
end