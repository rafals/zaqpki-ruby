class DisablingFeed < Feed
  belongs_to :deal
  belongs_to :disabler, :class_name => 'Account'
end