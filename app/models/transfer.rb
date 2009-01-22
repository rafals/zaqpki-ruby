class Transfer < ActiveRecord::Base
  belongs_to :sponsor, :class_name => 'Account'
  belongs_to :sponger, :class_name => 'Account'
  belongs_to :deal
  
  def after_create
    update_saldo(sponsor, sponger)
  end
  
  def after_destroy
    update_saldo(sponger, sponsor)
  end
  
  def update_saldo(gaining, losing)
    gaining_losing =  gaining.friendship losing
    gaining_losing.saldo -= cost
    gaining_losing.save
    losing_gaining = gaining_losing.reverted
    losing_gaining.saldo += cost
    losing_gaining.save
    
    gaining.mutual_friends(losing) do |mutual|
      mutual_gaining = mutual.friendship gaining
      mutual_losing = mutual.friendship losing
      mutual_gaining.saldo += cost
      mutual_gaining.save
      mutual_losing.saldo -= cost
      mutual_losing.save
    end
  end
end
