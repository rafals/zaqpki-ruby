class Friend < ActiveRecord::Base
  belongs_to :owner, :class_name => 'Account', :foreign_key => 'owner_id'
  belongs_to :account, :class_name => 'Account'
  
  def reverted
    account.friendship owner
  end
end
