class Comment < ActiveRecord::Base
  belongs_to :deal
  belongs_to :author, :class_name => 'Account'
  has_many :feeds, :dependent => :destroy
  
  after_create :create_feeds
  
  def create_feeds
    deal.observers do |observer|
      CommentFeed.create :account => observer, :comment => self
    end
  end
end