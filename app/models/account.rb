class Account < ActiveRecord::Base
  has_many :friends, :foreign_key => "owner_id"
  has_many :sponsored, :class_name => "Deal", :foreign_key => "sponsor_id"
  has_many :reported,  :class_name => "Deal", :foreign_key => "snitch_id"
  has_and_belongs_to_many :sponged, :class_name => "Deal"
  has_many :feeds
  validates_uniqueness_of :email, :name
  
  def update_saldos me_new
    account = me_new.account
    mutual_accounts_ids = [] # identyfikatory accountsów wspólnych znajomych
    
    mutual_friends(account) do |mutual|
      mutual_accounts_ids << mutual.id
    end
    
    # wyszukiwanie transferów pomiędzy new_friendem a mutualami
    new_mutual_transfers = Transfer.find_all_by_sponsor_id_and_sponger_id account.id, mutual_accounts_ids
    mutual_new_transfers = Transfer.find_all_by_sponsor_id_and_sponger_id mutual_accounts_ids, account.id
    
    # modyfikowanie salda friendów
    new_mutual_transfers.each do |transfer|
      me_mutual = friendship transfer.sponger
      me_mutual.saldo -= transfer.cost
      me_new.saldo += transfer.cost
      me_mutual.save
    end
    mutual_new_transfers.each do |transfer|
      me_mutual = friendship transfer.sponsor
      me_mutual.saldo += transfer.cost
      me_new.saldo -= transfer.cost
      me_mutual.save
    end
    me_new.save
    true
  end
  
  def mutual_friends he
    my_friends = {}
    friends.each do |f| 
      my_friends[f.account_id] = f
    end
    his_friends = {}
    he.friends.each do |f| 
      his_friends[f.account_id] = f
    end
    my_friends.each do |id, friend| 
      unless his_friends[id].nil?
        yield friend.account
      end
    end
  end
  
  def friendship account
    Friend.find_by_owner_id_and_account_id id, account.id
  end
  
  def knows? account
    account.id == self.id or !!(friendship account)
  end
  
  def connect account
    if knows? account
      return false
    end
    me_new = Friend.create :owner => self, :account => account
    new_me = Friend.create :owner => account, :account => self
    mutual_friends(account) do |mutual|
      FriendFeed.create :account => mutual, :friend => me_new
    end
    FriendFeed.create :account => self, :friend => me_new
    FriendFeed.create :account => account, :friend => me_new
    update_saldos me_new and account.update_saldos new_me
  end
  
  def saldo
    current_saldo = 0.0
    friends.each do |friend|
      current_saldo -= friend.saldo
    end
    current_saldo
  end
  
  def modelize ids
    unless ids.is_a? Array
      return Account.find ids
    end
    models = []
    if ids and ids.length > 0
      models = ids.map { |id| Account.find id }
    end
    models
  end
  
  def report description, cost, spongers_ids, sponsor_id = nil
    sponsor_id ||= id
    spongers = modelize spongers_ids
    spongers = [spongers] unless spongers.is_a? Array
    spongers.each do |sponger|
      return false unless (sponger.knows? modelize sponsor_id)
    end
    Deal.create :sponsor_id => sponsor_id, :cost => cost, :description => description, :snitch_id => id, :spongers => spongers
  end
  
  def self.authenticate email, password
    Account.find_by_email_and_password email, password
  end
end