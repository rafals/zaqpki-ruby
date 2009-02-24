class Invitation < ActiveRecord::Base
  belongs_to :to, :class_name => "Account"#, :foreign_key => "id"
  belongs_to :from, :class_name => "Account"#, :foreign_key => "id"
end
